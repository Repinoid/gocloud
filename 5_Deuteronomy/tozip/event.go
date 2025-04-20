package main

type APIGatewayRequest struct {
	OperationID string `json:"operationId"`
	Resource    string `json:"resource"`

	HTTPMethod string `json:"httpMethod"`

	Path           string            `json:"path"`
	PathParameters map[string]string `json:"pathParameters"`

	Headers           map[string]string   `json:"headers"`
	MultiValueHeaders map[string][]string `json:"multiValueHeaders"`

	QueryStringParameters           map[string]string   `json:"queryStringParameters"`
	MultiValueQueryStringParameters map[string][]string `json:"multiValueQueryStringParameters"`

	Parameters           map[string]string   `json:"parameters"`
	MultiValueParameters map[string][]string `json:"multiValueParameters"`

	Body            []byte `json:"body"`
	IsBase64Encoded bool   `json:"isBase64Encoded,omitempty"`

	RequestContext RequestContext `json:"requestContext"`
}

type RequestContext struct {
	Identity Identity `json:"identity"`

	HTTPMethod string `json:"httpMethod"`

	RequestId        string `json:"requestId"`
	RequestTime      string `json:"requestTime"`
	RequestTimeEpoch int64  `json:"requestTimeEpoch"`

	APIGateway APIGateway `json:"apiGateway"`
}
// ----------------------------
type RequestContext_1 struct {
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


type Identity struct {
	SourceIp  string `json:"sourceIp"`
	UserAgent string `json:"userAgent"`
}

type APIGateway struct {
	OperationContext map[string]string `json:"operationContext"`
}

type APIGatewayResponse struct {
	StatusCode        int                 `json:"statusCode"`
	Headers           map[string]string   `json:"headers"`
	MultiValueHeaders map[string][]string `json:"multiValueHeaders"`
	Body              string              `json:"body"`
	IsBase64Encoded   bool                `json:"isBase64Encoded,omitempty"`
}