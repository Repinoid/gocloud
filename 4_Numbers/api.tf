// https://terraform-provider.yandexcloud.net/resources/api_gateway
// https://yandex.cloud/ru/docs/api-gateway/
// Yandex API Gateway — сервис для управления API-шлюзами
resource "yandex_api_gateway" "apigat" {
  name        = "gateway2"
  description = "describas"

// templa.yaml - файл шаблона OpenAPI, в скобках - параметры, которые будут подставлены в шаблон 
  spec = templatefile("./templa.yaml", {
      // id сервисного аккаунта с ролью инвокера - разрешение на вызов функций через gateway
      invoker_said = yandex_iam_service_account.invoker-sa.id
      // resource "yandex_function" "goy" - прямой вывод метрик на экран
      fgoy = yandex_function.goy.id
      // запись ONE метрик в БД
      fputt = yandex_function.put2base.id
      // запись метрик в БД
      fwrite = yandex_function.write2bd.id
      // read метрик from БД
      fread = yandex_function.readbd.id
      // get ONE метрик from БД
      fgett = yandex_function.getfrombase.id
    }
  )
}

output "apiURL" {
  value = "   ${yandex_api_gateway.apigat.domain}  "
}

// Расширение x-yc-apigateway-integration:cloud_functions
// https://yandex.cloud/ru/docs/api-gateway/concepts/extensions/cloud-functions

// Пример интеграции API Gateway и Yandex Cloud Functions с использованием контекста операции.
// https://github.com/yandex-cloud-examples/yc-serverless-apigw-hello-world-go/tree/main