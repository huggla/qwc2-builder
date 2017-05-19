#!/bin/sh

usermod --login ${USER} user
groupmod --new-name ${USER} user
echo -n ${USER}':' >> /etc/shadow.org
cat /etc/shadow.org /run/secrets/user-pw > /etc/shadow
echo ':17304:0:99999:7:::' >> /etc/shadow
dropbear -FREwp 2222
