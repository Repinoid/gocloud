#================================ READER block ====================================
# create READER SERVICE ACCOUNT
resource "yandex_iam_service_account" "qu-read-sa" {
  name        = "queue-reading-service-account"
  folder_id   = var.folder_id
  description = "write service account for YMQ"
}
# create READER static ACCESS KEY
resource "yandex_iam_service_account_static_access_key" "qu-reader-static-key" {
  service_account_id = yandex_iam_service_account.qu-read-sa.id
  description        = "Static Key for YMQ READER"
}
# create READER role for service account
resource "yandex_resourcemanager_folder_iam_member" "queue-reader-role" {
  for_each = toset([
    "ymq.reader",
    "ydb.editor",
  ])
  role      = each.value
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.qu-read-sa.id}"
}
# create queue READ function
resource "yandex_function" "queue_read" {
  name               = "qu-reader"
  description        = "read from Message Queue"
  runtime            = "golang121"
  entrypoint         = "ymq_receiver.Receiver"
  memory             = "256"
  execution_timeout  = "110"
  service_account_id = yandex_iam_service_account.qu-read-sa.id
  log_options {
    min_level = "DEBUG"
  }
  environment = {
    AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.qu-reader-static-key.access_key
    AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.qu-reader-static-key.secret_key
    AWS_DEFAULT_REGION    = var.compute-default-zone
    QueueUrl_DSN          = yandex_message_queue.terra-queue.id # The URL of the Amazon SQS queue to which a message is sent. Queue URLs and names are case-sensitive.

    DATABASE_DSN          = var.dbEndpoint
  }
  user_hash = data.archive_file.lambda.output_base64sha256
  content { zip_filename = "goim.zip" }
}

# роль functions.functionInvoker - кто может вызывать функцию function_id :
# resource "yandex_function_iam_binding" "function-iamw" {
#   function_id = yandex_function.queue_write.id
#   role        = "functions.functionInvoker"
#   # members список сервисов, которые могут вызывать функцию
#   members = [  
#     "serviceAccount:${yandex_iam_service_account.qu-read-sa.id}",
#     "serviceAccount:${yandex_iam_service_account.queue-trigger-sa.id}",
    
#     #"system:allUsers", # делает функцию публичной, можно запускать через HTTP
#   ]
# }

# # output - вывод в консоль
# output "write_func" {
#   value = "https://functions.yandexcloud.net/${yandex_function.queue_write.id}"
# }

