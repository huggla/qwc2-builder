#!/bin/sh

usermod --login ${USER} user
groupmod --new-name ${USER} user
echo -n ${USER}':' >> /etc/shadow.org
cat /etc/shadow.org /run/secrets/user-pw > /etc/shadow
echo ':17304:0:99999:7:::' >> /etc/shadow
rm -f /home/user/.ssh/authorized_keys
if [ -e /run/secrets/ssh-authorized_keys ]
then
    cp /run/secrets/ssh-authorized_keys /home/user/.ssh/authorized_keys
else
    touch /run/secrets/ssh-authorized_keys
fi
if [ -e /run/secrets/ssh-themeupdate_key ]
then
    echo >> /run/secrets/ssh-authorized_keys
    echo -n 'no-port-forwarding,no-agent-forwarding,no-X11-forwarding,no-pty,command="/usr/local/bin/upd-qwc2-themes" >> /run/secrets/ssh-authorized_keys
    cat /run/secrets/ssh-themeupdate_key >> /run/secrets/ssh-authorized_keys
fi
chmod u=rw,go= /run/secrets/ssh-authorized_keys
dropbear -FREsjkmwp 2222
