#!/bin/bash
#
#author: il-da-r
#
echo "Скрипт создания сертификата пользователя openvpn (создается .crt, .key, .p12)"

#Настройки
#Папка rsa
dir_rsa='/etc/openvpn/keys/easy-rsa-old-master/easy-rsa/2.0'
#папка openvpn
dir_ovpn='/etc//openvpn/'
#Можно смонтировать папку в которую копировать сертификаты, чтобы вытащить их из системы
dir_mnt='/mnt/cert'

#scrypt
cd $dir_rsa
. ./vars
. ./build-key $1
cd keys
cp $1.crt $1.key $dir_ovpn/client
cd $dir_ovpn/client
openssl rsa -in $1.key -out $1_rsa.key
openssl pkcs12 -export -in $1.crt -inkey $1_rsa.key -certfile $dir_ovpn/ca.crt -name $1 -out $1.p12
echo "Создание сертификата завершено"
echo "Скопировать сертификат в папку cert? Y/n"
read copycert
case "copycert" in
    y|Y )
    cd /etc/openvpn/client
    cp $1.p12 $dir_mnt
    ;;
    * )
    echo "Копирование не выполнено"
    ;;
esac
