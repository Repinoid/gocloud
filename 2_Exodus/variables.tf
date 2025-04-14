/* в консоли набрать 

yc config list

выведутся все необходимые параметры. 
скопировать-прописать 

token: y0_AgAAAAAAaYTqAATuwQAAAADa-VEe7cBNbKf-S_GWWXhI7_Owk-3S1f0
cloud-id: b1gatc4m3hv1ldldhljp
folder-id: b1gj6dgm692ri5dl865t 
compute-default-zone: ru-central1-b

*/

variable "cloud_id" {
	type = string
	default = "b1gatc4m3hv1ldldhljp"
}
variable "compute-default-zone" {
	type = string
	default = "ru-central1-b"
}
variable "token" {
	type = string
	default = "y0__wgBEOqJpgMYwd0TIL3p7fMRMhA9PqLWjvofO_ynnO8gsmPPqq4"
}

variable "folder_id" {
	type = string
	default = "b1gj6dgm692ri5dl865t"
}
