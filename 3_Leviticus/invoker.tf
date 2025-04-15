
// SA для invoker
resource "yandex_iam_service_account" "invoker-sa" {  
  name        = "service-account-for-invoker"
  folder_id   = var.folder_id
  description = "service account for INVOKER"
}
// назначаем роль "вызывателя" функций
resource "yandex_resourcemanager_folder_iam_member" "invoker-role" {
  role        = "functions.functionInvoker"
  folder_id     = var.folder_id
  member       = "serviceAccount:${yandex_iam_service_account.invoker-sa.id}"
}
