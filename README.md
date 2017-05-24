# qwc2-builder
A Docker image with tools to build and update Qgis Web Client 2.

Environmental variables
-----------------------
USER=container_user_name

SSH_PORT=exposed_ssh_port

QWC2_GIT_BRANCH=git_branch_to_clone

QWC2_GIT_REPOSITORY=git_repository_to_clone

Volumes
-------
/run/secrets:
  1. /run/secrets/id_rsa contains private ssh key to use when cloning from Github.
  2. /run/secrets/user-pw contains encrypted password for USER. If user-pw is set then it is used for ssh authentication.
  3. /run/secrets/authorized_keys is used for ssh private key authentication. Is copied to ~/.ssh/authorized_keys.
  4. /run/secrets/ssh-themeupdate-key contains a public key used for ssh connection with theme update permission only.

/qwc2conf is where to put QWC2 configuration files.

/qwc2 will contain QWC2. Share it with a httpd server.

Executables
-----------
/usr/local/bin/entrypoint.sh is run at container start.

/usr/local/bin/clone-qwc2 clones QWC2 from Github.

/usr/local/bin/build-qwc2 builds QWC2 from cloned source. The result is saved to /qwc2.

/usr/local/bin/upd-qwc2-themes updates /qwc2 to latest configuration read from /qwc2conf.

Connect with ssh
----------------
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p SSH_PORT USER@containerAddress

Encrypting password
-------------------
perl -e "print crypt('myUnencryptedPassword','Q4')"
