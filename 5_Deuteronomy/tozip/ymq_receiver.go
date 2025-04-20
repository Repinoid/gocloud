package main

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"go.uber.org/zap"
)

// должен запускаться только триггером, invoke не катит
// Receiver  When working with Yandex Cloud Functions triggered by Yandex Message Queue (YMQ) messages, you'll receive events in the *YMQRequest format.
func Receiver(ctx context.Context, event *YMQRequest) (err error) {

	if event == nil {
		return errors.New("nil event received")
	}

	db, err := ConnectToBase(ctx)
	if err != nil {
		return err
	}
	defer db.Close(ctx)

	con := zap.NewProductionConfig()
	con.DisableCaller = true
	con.Level.SetLevel(zap.DebugLevel)
	logger, _ := con.Build()
	defer logger.Sync()

	resp := "resp \n"
	for _, message := range event.Messages {
		metras := map[string]float64{}
		json.Unmarshal([]byte(message.Details.Message.Body), &metras)

		err = putMetrics2Base(ctx, db, metras)
		if err != nil {
			return err
		}

		// for n, m := range metras {
		// 	fmt.Printf("%20s\t\t%g\n", n, m)
		// }

		resp += message.Details.Message.Body

	}

	logger.Debug(
		resp,
	)

	// YMQ-triggered functions automatically delete successfully processed messages
	// Automatic Deletion: For successfully processed messages (handler returns nil)
	return nil
}

type YMQRequest struct {
	Messages []YMQMessage `json:"messages"`
}

type YMQMessage struct {
	EventMetadata struct {
		EventID   string    `json:"event_id"`
		EventType string    `json:"event_type"`
		CreatedAt time.Time `json:"created_at"`
		CloudID   string    `json:"cloud_id"`
		FolderID  string    `json:"folder_id"`
	} `json:"event_metadata"`
	Details struct {
		QueueID string `json:"queue_id"`
		Message struct {
			MessageID         string            `json:"message_id"`
			MD5OfBody         string            `json:"md5_of_body"`
			Body              string            `json:"body"`
			Attributes        map[string]string `json:"attributes"`
			MessageAttributes map[string]struct {
				DataType    string `json:"data_type"`
				StringValue string `json:"string_value"`
			} `json:"message_attributes"`
			ReceiptHandle string `json:"receipt_handle"`
		} `json:"message"`
	} `json:"details"`
}
