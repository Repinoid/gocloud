package main

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	yc "github.com/yandex-cloud/go-sdk"
)

// GetConfig WithCredentialsProvider
func GetConfig(ctx context.Context, key, secret string) (cfg aws.Config, err error) {

	customResolver := aws.EndpointResolverWithOptionsFunc(func(service, region string, options ...interface{}) (aws.Endpoint, error) {
		return aws.Endpoint{
			URL:           "https://message-queue.api.cloud.yandex.net",
			SigningRegion: "ru-central1",
		}, nil
	})

	cfg, err = config.LoadDefaultConfig(
		ctx,
		config.WithEndpointResolverWithOptions(customResolver),
		config.WithCredentialsProvider(
			aws.NewCredentialsCache(
				aws.CredentialsProviderFunc(
					func(ctx context.Context) (aws.Credentials, error) {
						token, err := yc.InstanceServiceAccount().IAMToken(ctx)
						if err != nil {
							return aws.Credentials{}, err
						}
						return aws.Credentials{
							AccessKeyID:     key,            // yandex_iam_service_account_static_access_key access_key
							SecretAccessKey: secret,         // yandex_iam_service_account_static_access_key access_key secret_key
							SessionToken:    token.IamToken, // Actual authentication token
						}, nil
					},
				),
			)))
	return
}
