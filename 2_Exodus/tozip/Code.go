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
func Receiver(ctx context.Context) (*Response, error) {
	metras := GetMetric()

	for metr, value := range metras {
		fmt.Printf("%20s\t\t%g\n", metr, value)
	}

	return &Response{
		StatusCode: 200,
		Body:       metras,
	}, nil
}
