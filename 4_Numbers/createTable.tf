// https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/ydb_table
// Создание строковых таблиц в базе данных
// https://yandex.cloud/ru/docs/ydb/terraform/row-tables
resource "yandex_ydb_table" "metric_table" {
  path = "metrics"
  connection_string = var.dbEndpoint
  
column {
      name = "metricname"
      type = "Utf8"
      not_null = true
    }
    column {
      name = "value"
      type = "Double"
      not_null = true
    }
    column {
      name = "updated_at"
      type = "Timestamp"
      not_null = false
    }

  primary_key = ["metricname"]
  
}

// https://terraform-provider.yandexcloud.net/resources/ydb_database_iam_binding

// https://yandex.cloud/en/docs/functions/operations/trigger/timer-create