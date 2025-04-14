terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.compute-default-zone
}



# data "archive_file" "lambda" {
#   type        = "zip"
#   source_dir  = "./tozip/"
#   output_path = "queue.zip"
# }


#// https://yandex.cloud/ru/docs/functions/operations/trigger/ymq-trigger-create

# https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart#windows_1