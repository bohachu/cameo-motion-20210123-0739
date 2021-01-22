#!/bin/bash
if [ -f jupyterhub_cookie_secret ]; then
    rm jupyterhub_cookie_secret
fi
sudo openssl rand -hex 32 > jupyterhub_cookie_secret
sudo /bin/cp jupyterhub_cookie_secret /srv/jupyterhub/jupyterhub_cookie_secret
sudo chmod 600 /srv/jupyterhub/jupyterhub_cookie_secret
sudo systemctl restart jupyterhub.service
sudo rm jupyterhub_cookie_secret
# sudo systemctl stop jupyterhub.service
# sudo systemctl start jupyterhub.service
