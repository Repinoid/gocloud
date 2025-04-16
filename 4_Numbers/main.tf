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

// задаёт путь к папке с кодом программы, тип и имя файла архива. Папка в кодом зипуется и пересылается в Облако
// в облаке запускается процесс компилляции программы
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "./tozip/"
  output_path = "goim.zip"
}


