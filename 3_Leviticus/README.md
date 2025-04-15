# База данных

***Managed Service for YDB / Базы данных***<br>
Справа вверху - **Создать базу данных**<br>
Задаёте имя и выбираете Serverless<br>
*YDB автоматически выделяет и освобождает ресурсы исходя из пользовательской нагрузки, <br>
то есть исходя из объема хранимых данных и количества и сложности операций выполняемых с данными; <br>
в этом случае оплачивается стоимость выполнения операций и хранимых данных*

Правила тарификации для бессерверного режима Managed Service for YDB <br>
https://yandex.cloud/ru/docs/ydb/pricing/serverless
```
Фактическое потребление Request Units, менее 1 млн в месяц	Не тарифицируется
Хранение данных, менее 1 ГБ в месяц	Не тарифицируется
Исходящий трафик, первые 100 ГБ в месяц	Не тарифицируется
```
На странице созданной Базы Данных копируете Эндпоинт, выглядящий как  <br>
***grpcs://ydb.serverless.yandexcloud.net:2135/?database=/ru-central1/......***<br>
Скопируйте **variables.tf** из предыдущей темы Exodus и добавьте в него эти строки с вашим эндпоинтом в поле default
```
variable "dbEndpoint" {
	type = string
	default = "grpcs://ydb.serverless.yandexcloud.net:2135/?database=/ru-central1/b1ga........"
}
```
Далее всё за вас сделает Terraform, первым делом создав таблицу metrics<br>
Как обычно,  
```
terraform init
```
Затем
```
terraform apply
yc serverless function list
```
Три функции
```
goy-func
write-to-db
read-from-db
```
```
yc serverless function invoke write-to-db
```
Выведет *{"statusCode":200,"body":"Ok db.Endpoint ydb.serverless.yandexcloud.net:2135"}*
```
yc serverless function invoke read-from-db
```
*{"statusCode":200,"body":[{"mname":"Alloc","mvalue":11954960,"mdate":"2025-04-15T17:33:06Z"},* и прочие метрики<br>

База данных заработала. Можете посмотреть в Консоли Облака, войдя в Managed Service for YDB / выша база / metrics<br>