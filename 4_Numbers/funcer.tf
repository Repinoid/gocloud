// Сервисный аккаунт — аккаунт, от имени которого программы могут управлять ресурсами в Yandex Cloud.
// https://yandex.cloud/ru/docs/iam/concepts/users/service-accounts?from=int-console-help-center-or-nav
# create SERVICE ACCOUNT
resource "yandex_iam_service_account" "goy-sa" {
  name        = "goy-service-account"
  folder_id   = var.folder_id
  description = "service account for function"
}
// Статический ключ доступа необходим для аутентификации сервисного аккаунта в AWS-совместимых API.
// https://yandex.cloud/ru/docs/iam/concepts/authorization/access-key
# create  static ACCESS KEY
resource "yandex_iam_service_account_static_access_key" "goy-static-key" {
  service_account_id = yandex_iam_service_account.goy-sa.id
  description        = "Static Key for goy"
}
# create role for service account
resource "yandex_resourcemanager_folder_iam_member" "goy-role" {
  for_each = toset([
  //  "functions.functionInvoker",
  ])
  role      = each.value
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.goy-sa.id}"
}
# create function
resource "yandex_function" "goy" {
  name               = "goy-func"
  description        = "very first testing function"
  runtime            = "golang121"
  entrypoint         = "Code.Sender"
  memory             = "256"
  execution_timeout  = "110"
 service_account_id = yandex_iam_service_account.goy-sa.id
  environment = {
    AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.goy-static-key.access_key
    AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.goy-static-key.secret_key
    AWS_DEFAULT_REGION    = var.compute-default-zone
  }
  // Хеш архива с кодом. Обновляется при внесении изменений в код. Если хеш неизменен - компилляция не запускается
  user_hash = data.archive_file.lambda.output_base64sha256 
  content { zip_filename = "goim.zip" }
}

# роль functions.functionInvoker - КТО может вызывать функцию function_id :
resource "yandex_function_iam_binding" "function-iamw" {
  function_id = yandex_function.goy.id
  role        = "functions.functionInvoker"
  # members список сервисов, которые могут вызывать функцию
  members = [  
    "system:allUsers", # делает функцию публичной, можно запускать через HTTP
  ]
}


# output - вывод в консоль URL публичной функции
#output "metrics_func" {
#  value = "   https://functions.yandexcloud.net/${yandex_function.goy.id}  "
#}

// yc serverless function list
