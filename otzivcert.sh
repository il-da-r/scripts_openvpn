#!/bin/bash
#
# author: il-da-r
#
#Скрипт удаления  сертификата пользователя
#Запуск: .\otzivcert.sh имя_сертификата

###Настройки
#Папка rsa
dir_rsa='/etc/openvpn/keys/easy-rsa-old-master/easy-rsa/2.0'
#папка OpenVPN
dir_ovpn='/etc/openvpn'

#scrypt
echo -n "Продолжить? Вы удалете пользователя $1 (y/n) "
read item
case "$item" in
  y|Y)
    cd $dir_rsa
    . ./vars
    ./revoke-full $1
    cp ./keys/crl.pem $dir_ovpn
    chmod 644 $dir_ovpn/crl.pem
	echo -n "Продолжить? Перезапустить сервер openvpn (y/n) "
	read item2
	case "$item2" in
	y|Y)
	systemctl restart openvpn@server
	;;
	n|N) echo "Ввели «n», завершаем скрипт но необходимо будет затем вручную выполнить команду 'systemctl restart openvpn@server'"
	exit 0
	;;
	*) echo "Ничего не ввели. Завершаем скрипт но необходимо будет затем вручную выполнить команду 'systemctl restart openvpn@server'"
	;;
	esac
    ;;
   n|N) echo "Ввели «n», завершаем..."
    exit 0
    ;;
    *) echo "Ничего не ввели. завершаем"
    ;;
    esac

