/* yc config list
token: y0_AgAAAAAAaYTqAATuwQAAAADa-VEe7cBNbKf-S_GWWXhI7_Owk-3S1f0
cloud-id: b1gatc4m3hv1ldldhljp
folder-id: b1gj6dgm692ri5dl865t 
compute-default-zone: ru-central1-b
*/
variable "cloud_id" {
	type = string
	default = "b1gatc4m3hv1ldldhljp"
}
variable "folder_id" {
	type = string
	default = "b1gj6dgm692ri5dl865t"
}
variable "compute-default-zone" {
	type = string
	default = "ru-central1-b"
}
variable "token" {
	type = string
	default = "y0__wgBEOqJpgMYwd0TIL3p7fMRMhA9PqLWjvofO_ynnO8gsmPPqq4"
}
// Эндпоинт БД. Взять из Managed Service for YDB / Базы данных / база / Соединение
variable "dbEndpoint" {
	type = string
	default = "grpcs://ydb.serverless.yandexcloud.net:2135/?database=/ru-central1/b1gatc4m3hv1ldldhljp/etng5tv897avcvrror1v"
}
