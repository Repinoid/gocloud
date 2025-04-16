package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	"github.com/ydb-platform/ydb-go-sdk/v3/query"
)

// Sender получает метрики и формирует Body респонса, body выводится на экран
func Sender(ctx context.Context) (*Response, error) {
	metras := GetRuntimeMetric()
	outer := ""

	for metr, value := range metras {
		outer += fmt.Sprintf("%20s\t\t%g\n", metr, value)
	}
	fmt.Print("Serverless works NOW !!!")
	return &Response{
		StatusCode: 200,
		Body:       outer,
	}, nil
}

func ReadMetrics(ctx context.Context) (*Response, error) {

	db, err := ConnectToBase(ctx)
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"Service Unavailable"}`,
		}, err
	}
	defer db.Close(ctx)

	metras, err := getBaseMetrics(ctx, db)
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"Base metrics Unavailable"}`,
		}, err
	}

	return &Response{
		StatusCode: 200,
		Body:       metras,
	}, err
}

// WriteMetrics запись метрик в базу данных
func WriteMetrics(ctx context.Context) (*Response, error) {

	db, err := ConnectToBase(ctx)
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"DataBase Service Unavailable"}`,
		}, err
	}
	defer db.Close(ctx)

	metras := GetRuntimeMetric()

	err = db.Query().DoTx(ctx, func(ctx context.Context, t query.TxActor) error {
		for metr, value := range metras {
			order := ""
			if metr == "PollCount" { // PollCount - счётчик обновлений метрик, увеличить на 1
				order = "UPDATE metrics SET value=value+1, updated_at=CurrentUtcDatetime() WHERE metricname = 'PollCount' ;"
			} else {
				order = fmt.Sprintf("UPSERT INTO metrics (metricname, value, updated_at) VALUES ('%s', %g, CurrentUtcDatetime() ) ;", metr, value)
			}
			err = t.Exec(ctx, order)

			if err != nil {
				return err
			}
		}
		return err
	})
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"DataBase Write Error"}`,
		}, err
	}

	return &Response{
		StatusCode: 200,
		Body:       "Ok db.Endpoint " + db.Endpoint(),
	}, nil
}

// putOneMetrics запись одной метрики в базу данных
func PutOneMetric(ctx context.Context, event *APIGatewayRequest) (*Response, error) {
	// формат URL - <apiURL>/update/<mname>/<mvalue>
	operationContext := event.RequestContext.APIGateway.OperationContext

	mname, ok1 := operationContext["mname"]
	mvalue, ok2 := operationContext["mvalue"]
	if !ok1 || !ok2 {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"bad parameters, should be /update/<mname>/<mvalue>"}`,
		}, errors.New("bad paramaters")
	}

	db, err := ConnectToBase(ctx)
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"DataBase Service Unavailable"}`,
		}, err
	}
	defer db.Close(ctx)
	order := fmt.Sprintf("UPSERT INTO metrics (metricname, value, updated_at) VALUES ('%s', %s, CurrentUtcDatetime() ) ;", mname, mvalue)

	err = db.Query().Exec(ctx, order, query.WithTxControl(query.NoTx()))
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"metric was not written to DB"}`,
		}, err
	}

	return &Response{
		StatusCode: 200,
		Body:       fmt.Sprintf("Ok put metric %s value %s", mname, mvalue),
	}, nil
}

func GetOneMetric(ctx context.Context, event *APIGatewayRequest) (*Response, error) {
	// формат URL - <apiURL>/update/<mname>/<mvalue>
	operationContext := event.RequestContext.APIGateway.OperationContext

	mname, ok := operationContext["mname"]
	if !ok {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"bad parameters, should be /update/<mname>/<mvalue>"}`,
		}, errors.New("bad paramaters")
	}

	db, err := ConnectToBase(ctx)
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       `{"status":"DataBase Service Unavailable"}`,
		}, err
	}
	defer db.Close(ctx)

	order := fmt.Sprintf("SELECT value FROM metrics WHERE metricname='%s'; ", mname)
	row, err := db.Query().QueryRow(ctx, order, query.WithTxControl(query.NoTx()))
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       fmt.Sprintf("BAD scan metric %s ", mname),
		}, err
	}

	var val float64
	err = row.Scan(&val)
	if err != nil {
		return &Response{
			StatusCode: http.StatusServiceUnavailable, // 503
			Body:       fmt.Sprintf("BAD get metric %s value %g", mname, val),
		}, err
	}
	return &Response{
		StatusCode: http.StatusServiceUnavailable, // 503
		Body:       fmt.Sprintf("Ok get metric %s value %g", mname, val),
	}, err

}
