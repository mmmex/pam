## PAM

```
1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
2. Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис
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

* Запускаем ВМ: `vagrant up`

* Учитываем что если в момент проверки ДЗ в день недели отличный от указанных в задании выполнить вход не удастся. Иначе для проверки можем изменить проверку подменив текущим днем недели.

* Проверка задания: `ssh user1@localhost -p 2222` и `ssh user2@localhost -p 2222`

### 2. Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

Начиная с версии `Docker Engine v20.10` появился режим [rootless](https://docs.docker.com/engine/security/rootless/#prerequisites) (без рута), который позволяет обычному не привилегированному пользователю запускать docker контейнеры (смотреть ограничения в официальной документации). Я использовал polkit [правило для systemd](https://github.com/systemd/systemd/commit/88ced61bf9673407f4b15bf51b1b408fd78c149d), которое предоставляет возможность обычному пользователю управлять сервисами, в нашем случае `docker.service` и `docker.socket`, но это не сработает в centos 7 из коробки из-за отсутствия в версии `systemd 219` технической возможности действия `action.lookup("unit")`, поэтому необходимо добавить репозиторий [copr](https://copr.fedorainfracloud.org/coprs/jsynacek/systemd-backports-for-centos-7/) и обновить пакет `systemd`. Также в официальном репозитории centos 7 нет последней версии `docker`, его нужно добавить [официальный репозиторий docker](https://download.docker.com/linux/centos/docker-ce.repo).

* В скрипте предусмотрена провизия настройки, которая позволит обычному непривилегированному пользователю `user2` перезапускать докер сервис и работать с контейнерами.

* Если на предыдущем задании ВМ была запущено то пропускаем этот шаг, иначе запускаем ВМ: `vagrant up`

* Выполним вход: `ssh user2@localhost -p 2222` пароль `Otus2022`

* Выполним команду: `systemctl restart docker` и не увидим сообщения об отказе

* Запустим контейнер: `docker run hello-world`

```shell
[user2@hw14-pam ~]$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:faa03e786c97f07ef34423fccceeec2398ec8a5759259f94d99078f264e9d7af
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
