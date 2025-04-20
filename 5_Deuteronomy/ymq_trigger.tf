# create Trigger SERVICE ACCOUNT
resource "yandex_iam_service_account" "queue-trigger-sa" {
  name        = "queue-trigger-sa"
  folder_id   = var.folder_id
  description = "write service account for YMQ"
}


# create TRIGGER static ACCESS KEY
resource "yandex_iam_service_account_static_access_key" "queue-trigger-static-key" {
  service_account_id = yandex_iam_service_account.queue-trigger-sa.id
  description        = "Static Key for YMQ TRIGGER"
}


# create R/W & functionInvoker role for service account
resource "yandex_resourcemanager_folder_iam_member" "queue-trigger-role" {
  for_each = toset([
    "ymq.admin",
    "functions.functionInvoker",
  ])
  role      = each.value
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.queue-trigger-sa.id}"
}


# паривязка функции которую триггер запускает
resource "yandex_function_trigger" "ymq_trigger" {
  name        = "ymq-trigger"
  description = "запускает чтение из очереди когда в очередь приходит сообщение"
  message_queue {
    queue_id = yandex_message_queue.terra-queue.arn
    batch_cutoff = "0"  // задержка отправки
    batch_size = "5"
    service_account_id = yandex_iam_service_account.queue-trigger-sa.id
  }
  function {
    id = yandex_function.queue_read.id
    service_account_id = yandex_iam_service_account.queue-trigger-sa.id
  }
}

# паривязка функции которую триггер запускает
resource "yandex_function_trigger" "timer_trigger" {
  name        = "timer-trigger"
  description = "по таймеру запускает функцию записи в очередь"
  timer {
    cron_expression = "* * * * ? *"
  }
  function {
    id = yandex_function.queue_write.id
    service_account_id = yandex_iam_service_account.queue-trigger-sa.id
  }
}

