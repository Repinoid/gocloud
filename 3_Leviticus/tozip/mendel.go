package main

import "google.golang.org/protobuf/types/known/timestamppb"

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
