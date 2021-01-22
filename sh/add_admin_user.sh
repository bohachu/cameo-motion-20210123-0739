#!/usr/bin/env bash
# https://github.com/jupyterhub/ldapauthenticator/issues/54
# source post_add_admin_user.sh
source .env 

user=$1  
# userhome="/home/ad-domain/${user}"
userhome="/home/${user}"
if id "$1" &>/dev/null; then
    echo 'user already exists'
else
    echo 'user not found; creating user:'
    sudo useradd -m -p $(openssl passwd -6 ${user}) -G analysts ${user} 
    sudo cp -r /etc/skel/* /home/${user}/
    sudo chown -R ${user}:${user} /home/${user}/
fi

# post_add_admin_user ${user}


# set password
# sudo passwd ${user}

