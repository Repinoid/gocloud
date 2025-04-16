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
      // запись метрик в БД
      fwrite = yandex_function.write2bd.id
      // read метрик from БД
      fread = yandex_function.readbd.id
    }
  )
}

output "apiURL" {
  value = "   ${yandex_api_gateway.apigat.domain}  "
}
