# База данных
yc serverless function list
```
goy-func
write-to-db
read-from-db
```
```
yc serverless function invoke write-to-db
```
{"statusCode":200,"body":"Ok db.Endpoint ydb.serverless.yandexcloud.net:2135"}
```
yc serverless function invoke read-from-db
```
{"statusCode":200,"body":[{"mname":"Alloc","mvalue":11954960,"mdate":"2025-04-15T17:33:06Z"},