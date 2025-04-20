module github.com/Repinoid/gocloud

go 1.21

// github.com/shirou/gopsutil/v4@v4.25.3 requires go@1.23, but 1.21 is requested
require github.com/shirou/gopsutil/v4 v4.25.2 // поэтому v4.25.2

require (
	github.com/yandex-cloud/go-sdk v0.0.0-20250415134549-3e9c77f74bb7
	github.com/ydb-platform/ydb-go-sdk/v3 v3.106.1
)

require (
	github.com/ebitengine/purego v0.8.2 // indirect
	github.com/ghodss/yaml v1.0.0 // indirect
	github.com/go-ole/go-ole v1.2.6 // indirect
	github.com/golang-jwt/jwt/v4 v4.5.0 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/hashicorp/errwrap v1.0.0 // indirect
	github.com/hashicorp/go-multierror v1.1.1 // indirect
	github.com/jonboulle/clockwork v0.3.0 // indirect
	github.com/lufia/plan9stats v0.0.0-20211012122336-39d0f177ccd0 // indirect
	github.com/power-devops/perfstat v0.0.0-20210106213030-5aafc221ea8c // indirect
	github.com/tklauser/go-sysconf v0.3.12 // indirect
	github.com/tklauser/numcpus v0.6.1 // indirect
	github.com/yandex-cloud/go-genproto v0.0.0-20250415125903-e04f82fce08c // indirect
	github.com/ydb-platform/ydb-go-genproto v0.0.0-20241112172322-ea1f63298f77 // indirect
	github.com/yusufpapurcu/wmi v1.2.4 // indirect
	golang.org/x/net v0.33.0 // indirect
	golang.org/x/sync v0.10.0 // indirect
	golang.org/x/sys v0.28.0 // indirect
	golang.org/x/text v0.21.0 // indirect
	google.golang.org/genproto v0.0.0-20240903143218-8af14fe29dc1 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20240903143218-8af14fe29dc1 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20240903143218-8af14fe29dc1 // indirect
	google.golang.org/grpc v1.66.2 // indirect
	google.golang.org/protobuf v1.34.2
	gopkg.in/yaml.v2 v2.4.0 // indirect
)

require (
	// We cannot use the latest version of the aws-sdk-go-v2 because it BREAKS the compatibility with the YMQ.
	// https://github.com/aws/aws-sdk-go-v2/issues/2370
	github.com/aws/aws-sdk-go-v2 v1.22.1
	github.com/aws/aws-sdk-go-v2/config v1.20.0
	github.com/aws/aws-sdk-go-v2/credentials v1.14.0 // indirect
	// We cannot use the latest version of the sqs because it uses new JSON protocol v1 which is not supported
	// by YMQ. Latest version of the sqs which uses query protocol is v1.26.0. And as it is version from 2023-11-01
	// it is not compatible with the aws-sdk-go-v2 greater than v1.22.2.
	github.com/aws/aws-sdk-go-v2/service/sqs v1.26.0
	github.com/aws/smithy-go v1.17.0 // indirect
)

require go.uber.org/zap v1.27.0

require (
	github.com/aws/aws-sdk-go-v2/feature/ec2/imds v1.14.0 // indirect
	github.com/aws/aws-sdk-go-v2/internal/configsources v1.2.1 // indirect
	github.com/aws/aws-sdk-go-v2/internal/endpoints/v2 v2.5.1 // indirect
	github.com/aws/aws-sdk-go-v2/internal/ini v1.4.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/presigned-url v1.10.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/sso v1.16.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/ssooidc v1.18.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/sts v1.24.0 // indirect
	go.uber.org/multierr v1.10.0 // indirect
)
