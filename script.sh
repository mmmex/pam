#!/usr/bin/env bash

yum update -y
#yum install docker -y
#chkconfig docker on

#systemctl restart dbus

groupadd admins

useradd -g admins user1
useradd -g users user2

echo "Otus2022" | sudo passwd --stdin user1
echo "Otus2022" | sudo passwd --stdin user2

cp /vagrant/weekend_login.sh /usr/local/bin

sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service
sed -i '/account.*required.*pam_nologin.so/a account    required     pam_exec.so /usr/local/bin/weekend_login.sh' /etc/pam.d/sshd

