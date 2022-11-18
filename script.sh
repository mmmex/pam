#!/usr/bin/env bash

yum install wget -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
wget --no-check-certificate https://copr.fedorainfracloud.org/coprs/jsynacek/systemd-backports-for-centos-7/repo/epel-7/jsynacek-systemd-backports-for-centos-7-epel-7.repo -O /etc/yum.repos.d/jsynacek-systemd-centos-7.repo
yum update systemd -y

groupadd admins

useradd -g admins user1
useradd -g users user2
usermod -aG docker user2

echo "Otus2022" | sudo passwd --stdin user1
echo "Otus2022" | sudo passwd --stdin user2

cp /vagrant/weekend_login.sh /usr/local/bin
cp /vagrant/01-manage-docker.rules /etc/polkit-1/rules.d

sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service
sed -i '/account.*required.*pam_nologin.so/a account    required     pam_exec.so /usr/local/bin/weekend_login.sh' /etc/pam.d/sshd

systemctl enable docker.service
systemctl enable docker.socket
systemctl start docker.service docker.socket
