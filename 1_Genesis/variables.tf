/* в консоли набрать 

yc config list

выведутся все необходимые параметры. 
скопировать-прописать 

token: y0_AgA......................
cloud-id: b1gat............
folder-id: b1gj6dgm..........
compute-default-zone: ru-central1-?

*/

variable "cloud_id" {
	type = string
	default = "b1gat..........."
}
variable "compute-default-zone" {
	type = string
	default = "ru-central1-?"
}
variable "token" {
	type = string
	default = "y0__wgB................."
}

variable "folder_id" {
	type = string
	default = "b1gj............."
}
