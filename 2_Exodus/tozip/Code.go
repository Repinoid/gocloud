package main

import (
	"context"
	"fmt"
)

type Response struct {
	StatusCode int         `json:"statusCode"`
	Body       interface{} `json:"body"`
}

//goland:noinspection GoUnusedExportedFunction
func Sender(ctx context.Context) (*Response, error) {
	metras := GetMetric()
	outer := ""

	for metr, value := range metras {
		outer += fmt.Sprintf("%20s\t\t%g\n", metr, value)
	}

	return &Response{
		StatusCode: 200,
		Body:       outer,
	}, nil
}
