package main

import (
	"context"
	"encoding/json"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
)

type Responce struct {
	StatusCode int         `json:"statusCode"`
	Body       interface{} `json:"body"`
}
type Message struct {
	Body string `json:"body"`
}

func SendMessage(ctx context.Context) (err error) {

	cfg, err := GetConfig(ctx, os.Getenv("AWS_ACCESS_KEY_ID"), os.Getenv("AWS_SECRET_ACCESS_KEY"))
	if err != nil {
		return err
	}
	// Your queue URL
	queueURL := os.Getenv("QueueUrl_DSN")

	// Create SQS client
	client := sqs.NewFromConfig(cfg)

	metras := GetRuntimeMetric()
	metrasJSON, _ := json.Marshal(metras)

	// Send message
	mout, err := client.SendMessage(ctx, &sqs.SendMessageInput{
		QueueUrl:    &queueURL,
		MessageBody: aws.String(string(metrasJSON)),
	})

	// An attribute containing the MessageId of the message sent to the queue.
	_ = mout.MessageId

	// nil  if err == nil
	return err
}
