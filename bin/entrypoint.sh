#!/bin/sh

useradd $USER
echo '$USER:$PASSWORD' | chpasswd
dropbear -FR
