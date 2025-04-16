#Yandex API Gateway

https://yandex.cloud/ru/docs/api-gateway/<br>

>Yandex API Gateway — сервис для управления API-шлюзами, поддерживающий спецификацию OpenAPI 3.0 и набор расширений для взаимодействия с другими облачными сервисами.

В нашем случае можно сказать, что API Gateway это рутер, маршрутизатор, запускающий функции в зависимости от параметров URL

В файле api.tf описывается создание **resource "yandex_api_gateway" "apigat"**
В шаблон, находящийся в templa.yaml, подставляются идентификаторы функций, и терраформ формирует Gateway
> Должно заметить, что расширение шаблонов должно быть **tftpl**, но с **yaml** VS Code проще работать

Как всегда 
- скопировать variables.tf из предыдущей темы
- terraform init
- terraform apply
В итоге - ссылка на URL API типа
apiURL = "   d5------------i64.g3a---ln.apigw.yandexcloud.net  "
Копируете то что меж кавычек, вставляете в браузер, получите ***Hello, every buddy!***
- **<URL>/mlook** - запустится старый знакомый goy
