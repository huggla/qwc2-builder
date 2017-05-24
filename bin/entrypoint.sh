#!/bin/sh

if [ "`id -u user > /dev/null 2>&1; echo $?`" -eq 0 ]
then
    usermod --login ${USER} user
    groupmod --new-name ${USER} user
fi
if [ -s /run/secrets/user-pw ]
then
    echo -n ${USER}':' >> /etc/shadow.org
    cat /etc/shadow.org /run/secrets/user-pw > /etc/shadow
    echo ':17304:0:99999:7:::' >> /etc/shadow
fi
if [ -s /run/secrets/authorized_keys ] || [ -s /run/secrets/ssh-themeupdate-key ]
then
    if [ -s /run/secrets/authorized_keys ]
    then
        cp /run/secrets/authorized_keys /home/user/.ssh/authorized_keys
        echo >> /home/user/.ssh/authorized_keys
    else
        > /home/user/.ssh/authorized_keys
    fi
    if [ -s /run/secrets/ssh-themeupdate-key ]
    then
        echo -n 'no-port-forwarding,no-agent-forwarding,no-X11-forwarding,no-pty,command="/usr/local/bin/upd-qwc2-themes" ' >> /home/user/.ssh/authorized_keys
        cat /run/secrets/ssh-themeupdate-key >> /home/user/.ssh/authorized_keys
        echo >> /home/user/.ssh/authorized_keys
    fi
    chown ${USER}:${USER} /home/user/.ssh/authorized_keys
    chmod u=rw,go= /home/user/.ssh/authorized_keys
fi
if [ -s /run/secrets/user-pw ]
then
    echo 'Starting ssh with password authentication enabled'
    echo "dropbear -FREjkmwp ${SSH_PORT}"
    dropbear -FREjkmwp ${SSH_PORT}
else
    echo 'Starting ssh with public key authentication'
    echo "dropbear -FREsjkmwp ${SSH_PORT}"
    dropbear -FREsjkmwp ${SSH_PORT}
fi
exit
