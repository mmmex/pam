## PAM

```
1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
2. дать конкретному пользователю права работать с докером и возможность рестартить докер сервис
```

### 1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

* Подготовлен [Vagrantfile](Vagrantfile), а также [скрипт](script.sh), который автоматически подготовит стенд для демонстрации.

* Скрипт добавит новую группу `admins`, два новых пользователя `user1` и `user2`. Группа `users` уже имеется из коробки.

* Учетную запись `user1` добаит в группу `admins`, а `user2` в группу `users`. Пароль одинаковый на обеих учетках: `Otus2022`

* Согласно условиям задания подготовлен [скрипт](weekend_login.sh), который проверяет несколько условий: 

1. Совпадение текущего дня недели (суббота или воскресенье) и если совпадение найдено будет обрабатывать следующее условие;

2. Если текущий пользователь находится в группе `admins`, то скрипт вернет `exit 0` и разрешит учетной записи выполнить вход, иначе возвращает `exit 1` и вход будет запрещен.

* Выше указанный [скрипт](weekend_login.sh) будет добавлен в стэк проверок для сервиса `sshd` в файл `/etc/pam.d/sshd`

* Также будет поправлен конфигурационный файл `sshd` для разрешения авторизации по паролю.

* Клонируем проект: `git clone https://github.com/mmmex/pam.git`

* Запускаем: `vagrant up`

* Учитываем что если в момент проверки ДЗ в день недели отличный от указанных в задании выполнить вход не удастся.

* Проверка задания: `ssh user1@localhost -p 2222`
