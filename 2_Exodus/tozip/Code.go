package main

import (
	"context"
	"fmt"
)

type Response struct {
	StatusCode int    `json:"statusCode"`
	Body       string `json:"body"`
}

// Sender получает метрики и формирует Body респонса
func Sender(ctx context.Context) (*Response, error) {
	metras := GetMetric()
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
