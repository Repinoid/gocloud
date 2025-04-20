#================================ WRITER block ====================================
# create WRITER SERVICE ACCOUNT
resource "yandex_iam_service_account" "qu-writer-sa" {
  name        = "queue-writing-service-account"
  folder_id   = var.folder_id
  description = "write service account for YMQ"
}
# create WRITER static ACCESS KEY
resource "yandex_iam_service_account_static_access_key" "qu-writer-static-key" {
  service_account_id = yandex_iam_service_account.qu-writer-sa.id
  description        = "Static Key for YMQ WRITER"
}
# create WRITE role for service account
resource "yandex_resourcemanager_folder_iam_member" "queue-write-role" {
  for_each = toset([
    "ymq.writer",
  ])
  role      = each.value
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.qu-writer-sa.id}"
}
# create queue WRITE function
resource "yandex_function" "queue_write" {
  name               = "qu-writer"
  description        = "write 2 Message Queue"
  runtime            = "golang121"
  entrypoint         = "ymq_writer.SendMessage"
  memory             = "256"
  execution_timeout  = "110"
  service_account_id = yandex_iam_service_account.qu-writer-sa.id
  log_options {
    min_level = "DEBUG"
  }
  environment = {
    AWS_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.qu-writer-static-key.access_key
    AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.qu-writer-static-key.secret_key
    AWS_DEFAULT_REGION    = var.compute-default-zone
    QueueUrl_DSN          = yandex_message_queue.terra-queue.id # The URL of the Amazon SQS queue to which a message is sent. Queue URLs and names are case-sensitive.
  }
  user_hash = data.archive_file.lambda.output_base64sha256
  content { zip_filename = "goim.zip" }
}

# # роль functions.functionInvoker - кто может вызывать функцию function_id :
# resource "yandex_function_iam_binding" "function-iamw" {
#   function_id = yandex_function.queue_write.id
#   role        = "functions.functionInvoker"
#   # members список сервисов, которые могут вызывать функцию
#   members = [  
#     "serviceAccount:${yandex_iam_service_account.qu-writer-sa.id}",
#     #"system:allUsers", # делает функцию публичной, можно запускать через HTTP
#   ]
# }
# # output - вывод в консоль
# output "write_func" {
#   value = "https://functions.yandexcloud.net/${yandex_function.queue_write.id}"
# }

