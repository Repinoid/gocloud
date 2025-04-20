package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
)

// RuntimeMetrics получает метрики directly from Runtime и формирует Body респонса, body выводится на экран
func RuntimeMetrics(ctx context.Context) (*Response, error) {
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

// ReadMetrics read metrics from Data Base
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

	outer := ""
	for _, metr := range metras {
		outer += fmt.Sprintf("%20s\t\t%20g\t\t%v\n", metr.Metricname, metr.Value, metr.Updated_at)
	}

	return &Response{
		StatusCode: 200,
		Body:       outer,
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

	err = putMetrics2Base(ctx, db, metras)

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

// putOneMetrics запись одной метрики в базу данных. формат URL - <apiURL>/update/<metric name>/<metric value>
func PutOneMetric(ctx context.Context, event *APIGatewayRequest) (*Response, error) {
	
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

	err = puttyM(ctx, db, mname, mvalue)

	return &Response{
		StatusCode: 200,
		Body:       fmt.Sprintf("put metric %s value %s", mname, mvalue),
	}, err
}
// GetOneMetric Get One Metric from Data Base. формат URL - <apiURL>/value/<metric name>
func GetOneMetric(ctx context.Context, event *APIGatewayRequest) (*Response, error) {
	
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

	val, err := gettyM(ctx, db, mname)

	return &Response{
		StatusCode: http.StatusServiceUnavailable, // 503
		Body:       fmt.Sprintf("Ok get metric %s value %g", mname, val),
	}, err

}
