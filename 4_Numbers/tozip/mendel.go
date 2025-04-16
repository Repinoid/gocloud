package main

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"
)

type Metrics struct {
	ID    string `json:"id"`   // имя метрики
	MType string `json:"type"` // параметр, принимающий значение gauge или counter
}

// TokStruct структура для получения токена
type TokStruct struct {
	Token     string                 `json:"access_token"`
	ExpireAt  *timestamppb.Timestamp `json:"expires_in"`
	TokenType string                 `json:"token_type"`
}

type Response struct {
	StatusCode int         `json:"statusCode"`
	Body       interface{} `json:"body"`
}

type HttpEvent struct {
	HttpMethod                      string              `json:"httpMethod"`
	Headers                         map[string]string   `json:"headers"`
	MultiValueHeaders               map[string][]string `json:"multiValueHeaders"`
	QueryStringParameters           map[string]string   `json:"queryStringParameters"`
	MultiValueQueryStringParameters map[string][]string `json:"multiValueQueryStringParameters"`
	//	RequestContext                  RequestContext      `json:"requestContext"`
	Body            string `json:"body"`
	IsBase64Encoded bool   `json:"isBase64Encoded"`
}

type RequestContext struct {
	Identity struct {
		SourceIp  string `json:"sourceIp"`
		UserAgent string `json:"userAgent"`
	}
	HttpMethod       string      `json:"httpMethod"`
	RequestId        string      `json:"requestId"`
	RequestTime      string      `json:"requestTime"`
	RequestTimeEpoch int         `json:"requestTimeEpoch"`
	Authorizer       interface{} `json:"authorizer"`
	ApiGateway       struct {
		OperationContext interface{} `json:"operationContext"`
	} `json:"apiGateway"`
}

type metroBase struct {
	Metricname string    `json:"mname"`
	Value      float64   `json:"mvalue"`
	Updated_at time.Time `json:"mdate"`
}
