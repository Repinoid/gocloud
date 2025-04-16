package main

import (
	"context"
	"encoding/json"
	"fmt"

	ycsdk "github.com/yandex-cloud/go-sdk"
)

// https://yandex.cloud/ru/docs/functions/lang/golang/context
// GetToken - получение токена из контекста
// func GetToken(ctx context.Context) (tok models.TokStruct, err error) {
func GetToken(ctx context.Context) (tok TokStruct, err error) {

	creds := ycsdk.InstanceServiceAccount()
	ycsdkToken, err := creds.IAMToken(ctx)
	if err != nil {
		return
	}
	// В поле token.IamToken будет находиться необходимый IAM-токен.
	tok.Token = ycsdkToken.IamToken
	tok.ExpireAt = ycsdkToken.ExpiresAt

	return
}

// GetToken_Alternative - недокументировано, not used
func GetToken_Alternative(ctx context.Context) (tok TokStruct, err error) {
	// Получение токена через ctx.Value("lambdaRuntimeTokenJSON") заимствовано отсюда https://nikolaymatrosov.ru/examples/go/postbox/
	tokenValue, ok := ctx.Value("lambdaRuntimeTokenJSON").(string)
	if !ok {
		return tok, fmt.Errorf("unexpected token type %T", tokenValue)
	}
	err = json.Unmarshal([]byte(tokenValue), &tok)
	if err != nil {
		return
	}
	return
}
