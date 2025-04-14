# Genesis
## Начало работы с интерфейсом командной строки <br>
По ссылке https://yandex.cloud/ru/docs/cli/quickstart <br>
Выполнить всё до ***Примеры команд*** <br>

настройки вашего профиля CLI: выполните
```
yc config list
```
Скопируйте значения ***token, cloud-id, folder-id, compute-default-zone*** <br>
в соответствующие поля файла variables.tf <br>
Подсказки по командам CLI - флаг -h. <br>
Например, ***yc -h<br>yc <команда> -h*** <br>

## Инициализация терраформа
Терраформ испытывает к нам лишнюю неприязнь, так что лучше не мучиться и запустить *сами-знаете-что*<br>
https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart <br>
Выполните всё до **Подготовьте план инфраструктуры**

Команды терраформа надо запускать из консоли, находясь в папке с файлами .tf<br>
Наберите
```
terraform init
```
Должно вывестись бла-бла-бла **Terraform has been successfully initialized!** бла-бла-бла <br>
```
terraform validate
```
--> Success! The configuration is valid<br>
```
terraform plan
```
--> No changes. Your infrastructure matches the configuration.<br>
terraform plan - это и есть план, выводит список вновь образуемых ресурсов, не производя ничего, так сказать, dry-run<br>
```
terraform apply
```
apply уже "рабочая" команда, создаёт/меняет/удаляет ресурсы. Пока их нет, поэтому и No changes.<hr>
Если всё сработало корректно - облако и терраформ готовы к работе.<br>
В п.2 Exodus соорудим Serverless Function