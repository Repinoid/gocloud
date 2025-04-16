// Создание функции https://yandex.cloud/ru/docs/functions/operations/function/function-create#tf_1
// https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/function
// 

// Service Account для функции записи в БД
resource "yandex_iam_service_account" "ydb-editor-sa" {  
  name        = "sa-ydb-write"
  folder_id   = var.folder_id
  description = "service account for write to Data Base"
}
 
// Роль ydb.editor позволяет управлять базами данных, схемными объектами и резервными копиями БД, 
// а также выполнять запросы к БД на чтение и запись данных.
resource "yandex_resourcemanager_folder_iam_member" "ydb-editor-role" {
  role          = "ydb.editor"
  folder_id     = var.folder_id
  member       = "serviceAccount:${yandex_iam_service_account.ydb-editor-sa.id}"
}
# create static KEY. Создание ключей для сервисного аккаунта
resource "yandex_iam_service_account_static_access_key" "ydb-editor-key" {
  service_account_id = yandex_iam_service_account.ydb-editor-sa.id
  description        = "Static Key for ydb-write-sa"
}
// запись всех метрик в БД
resource "yandex_function" "write2bd" {
  name               = "write-to-db"
  description        = "write metrics to Data Base"

// Для перекомпилляции функции необходимо изменить значение user_hash. Он определяется как хеш архива с кодом
  user_hash          = data.archive_file.lambda.output_base64sha256 

  runtime            = "golang121"
  // путь до функции
  entrypoint         = "handlers.WriteMetrics"  
  
  memory             = "256"
  execution_timeout  = "10"

  // service_account_id - от чьего имени запускается функция. см. sas.tf
  service_account_id = yandex_iam_service_account.ydb-editor-sa.id

  // переменные окружения
  environment = {
      AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.ydb-editor-key.access_key
      AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.ydb-editor-key.secret_key
      AWS_DEFAULT_REGION    = var.compute-default-zone
      
      DATABASE_DSN          = var.dbEndpoint
    }
  content {
        zip_filename =  "goim.zip"  // файл с упакованным кодoм функции
    }
}
// запись одной метрики в БД
resource "yandex_function" "put2base" {
  name               = "put-to-db"
  description        = "write one metric to Data Base"

// Для перекомпилляции функции необходимо изменить значение user_hash. Он определяется как хеш архива с кодом
  user_hash          = data.archive_file.lambda.output_base64sha256 

  runtime            = "golang121"
  // путь до функции
  entrypoint         = "handlers.PutOneMetric"  
  
  memory             = "256"
  execution_timeout  = "10"

  // service_account_id - от чьего имени запускается функция. см. sas.tf
  service_account_id = yandex_iam_service_account.ydb-editor-sa.id

  // переменные окружения
  environment = {
      AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.ydb-editor-key.access_key
      AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.ydb-editor-key.secret_key
      AWS_DEFAULT_REGION    = var.compute-default-zone
      
      DATABASE_DSN          = var.dbEndpoint
    }
  content {
        zip_filename =  "goim.zip"  // файл с упакованным кодoм функции
    }
}
// чтение всех метрик из БД
resource "yandex_function" "readbd" {
  name               = "read-from-db"
  description        = "read metrics from Data Base"

// Для перекомпилляции функции необходимо изменить значение user_hash. Он определяется как хеш архива с кодом
  user_hash          = data.archive_file.lambda.output_base64sha256 

  runtime            = "golang121"
  // путь до функции
  entrypoint         = "handlers.ReadMetrics"  
  
  memory             = "256"
  execution_timeout  = "10"

  // service_account_id - от чьего имени запускается функция. см. sas.tf
  service_account_id = yandex_iam_service_account.ydb-editor-sa.id

  // переменные окружения
  environment = {
      AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.ydb-editor-key.access_key
      AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.ydb-editor-key.secret_key
      AWS_DEFAULT_REGION    = var.compute-default-zone
      
      DATABASE_DSN          = var.dbEndpoint
    }
  content {
        zip_filename =  "goim.zip"  // файл с упакованным кодoм функции
    }
}
// чтение ONE метрик из БД
resource "yandex_function" "getfrombase" {
  name               = "read-one-metric"
  description        = "read one metric from Data Base"

// Для перекомпилляции функции необходимо изменить значение user_hash. Он определяется как хеш архива с кодом
  user_hash          = data.archive_file.lambda.output_base64sha256 

  runtime            = "golang121"
  // путь до функции
  entrypoint         = "handlers.GetOneMetric"  
  
  memory             = "256"
  execution_timeout  = "10"

  // service_account_id - от чьего имени запускается функция. см. sas.tf
  service_account_id = yandex_iam_service_account.ydb-editor-sa.id

  // переменные окружения
  environment = {
      AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.ydb-editor-key.access_key
      AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.ydb-editor-key.secret_key
      AWS_DEFAULT_REGION    = var.compute-default-zone
      
      DATABASE_DSN          = var.dbEndpoint
    }
  content {
        zip_filename =  "goim.zip"  // файл с упакованным кодoм функции
    }
}
//
# кто может вызывать функцию:
resource "yandex_function_iam_binding" "function-putt" {
  function_id = yandex_function.put2base.id
  role        = "functions.functionInvoker"
  members = [
    "serviceAccount:${yandex_iam_service_account.invoker-sa.id}", // список сервисов, которые могут запускать функцию
  ]
}
resource "yandex_function_iam_binding" "function-gett" {
  function_id = yandex_function.getfrombase.id
  role        = "functions.functionInvoker"
  members = [
    "serviceAccount:${yandex_iam_service_account.invoker-sa.id}", 
  ]
}
resource "yandex_function_iam_binding" "function-write" {
  function_id = yandex_function.write2bd.id
  role        = "functions.functionInvoker"
  members = [
    "serviceAccount:${yandex_iam_service_account.invoker-sa.id}", 
  ]
}
resource "yandex_function_iam_binding" "function-read" {
  function_id = yandex_function.readbd.id
  role        = "functions.functionInvoker"
  members = [
    "serviceAccount:${yandex_iam_service_account.invoker-sa.id}", 
  ]
}
