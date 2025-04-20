# ======================== YMQ Block =============================
# Сначала создаём сервисный аккаунт, дaлее - SA
# create YQM SERVICE ACCOUNT
resource "yandex_iam_service_account" "queue-sa" {
  name        = "queue-service-account"
  folder_id   = var.folder_id
  description = "service account for Message Queue"
}


# Создаём ключи для SA
resource "yandex_iam_service_account_static_access_key" "queue-static-key" {
  service_account_id = yandex_iam_service_account.queue-sa.id
  description        = "Static Key"
}


# https://yandex.cloud/ru/docs/iam/roles-reference#message-queue-roles
# список ролей для SA - что разрешённо делать от имени данного SA
# Роль ymq.admin включает права ролей ymq.reader и ymq.writer, а также дает права изменять атрибуты очередей и удалять очереди. 
# Позволяет получать список очередей и информацию о них.
resource "yandex_resourcemanager_folder_iam_member" "queue-sa-roles" {
  for_each = toset([
    "ymq.admin",
  ])
  role      = each.value
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.queue-sa.id}"
}


#https://yandex.cloud/en/docs/message-queue/instruments/terraform
# собственно очередь
resource "yandex_message_queue" "terra-queue" {
  name                       = "queue-by-terraform"
  visibility_timeout_seconds = 60
  receive_wait_time_seconds  = 0
  message_retention_seconds  = 1209600
  access_key                 = yandex_iam_service_account_static_access_key.queue-static-key.access_key
  secret_key                 = yandex_iam_service_account_static_access_key.queue-static-key.secret_key
}


// yc serverless function invoke queue-writer
// yc serverless function logs queue-receiver