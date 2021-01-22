#!/bin/bash
# 起始執行目錄: 專案目錄/sh
# 請先把sh變成可以執行: chmod a+x *.sh
# 請先設定好nginx
# after install, launch with: 
# jupyterhub: sudo systemctl start jupyterhub.service or
#     /opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
# jupyterhub設定檔: 專案目錄/sh/jupyter_config.py -> /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
# 修改設定後重啟服務: ./update_jupyterhub_config_then_restart.sh
# nginx設定檔: cp 專案目錄/sh/nginx_http.conf
# 靜態網頁目錄: cp 專案目錄/src 
# cd /home/$USER/$PRJ_DIR_NAME/sh
# rm /home/$USER/$PRJ_DIR_NAME/sh/.env
echo "準備設定檔"
if [[ ! -f .env ]]; then
    echo "Copying environment template..."
    cp .env-template .env
    sudo chmod 600 .env
fi
if [[ ! -f etc_skel/.user-env ]]; then
    cp etc_skel/.user-env-template etc_skel/.user-env
fi
source .env

echo "設定時區為Taipei時區"
sudo timedatectl set-timezone Asia/Taipei

cd /home/$INSTALL_USER/

# conda ppa
echo "Add conda ppa and install conda."
curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
sudo install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/
sudo echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" | sudo tee /etc/apt/sources.list.d/conda.list
sudo apt update && sudo apt install conda --upgrade -y && \
    sudo apt clean -y && \
    sudo apt -y autoremove 

# # postgresql ppa
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
# sudo apt install postgresql-12 postgresql-client-12  --upgrade -y

# vscode ppa
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt install apt-transport-https
# sudo apt update && sudo apt install code -y

# sudo /opt/jupyterhub/bin/python3 -m pip install keplergl opencv-python
# sudo ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
# sudo add-apt-repository -y ppa:ubuntugis/ppa && \
echo "Install system libraries."
sudo apt update && \
    sudo apt install --upgrade -y \
    python3 python3-dev  python3-venv \
    curl wget sudo cron joe nano \
    zip unzip file fonts-dejavu acl libpq-dev 
    
sudo apt install --upgrade -y \
    apt-utils ffmpeg libssl1.1 libssl-dev \
    libxtst6 xvfb xdotool wmctrl cmake \
    tzdata graphviz graphviz-dev \
    libxml2-dev libxslt-dev libjpeg-dev zlib1g-dev libpng-dev  \
    software-properties-common 

sudo apt install git-lfs mc nginx && \
    sudo export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib && \
    sudo apt clean -y && \
    sudo apt -y autoremove 

# sudo add-apt-repository -y ppa:ubuntugis/ppa

sudo apt install nodejs npm -y && \
    sudo apt clean -y && \
    sudo apt -y autoremove 

echo "Install Python3, Jupyterhub, Jupyterlab libraries."
sudo python3 -m venv /opt/jupyterhub/
sudo /opt/jupyterhub/bin/python3 -m pip install --upgrade pip --no-cache-dir 
sudo /opt/jupyterhub/bin/python3 -m pip install \
    wheel jupyterhub jupyterlab ipywidgets jupyterhub-nativeauthenticator \
    nbgitpuller voila voila-gridstack ipyleaflet \
    nbgitpuller google-cloud-storage pandas scikit-learn widgetsnbextension \
    pandas matplotlib ipympl numba numexpr xlrd psycopg2 ipyleaflet jupyterlab_iframe \
    --no-cache-dir

# pip install 
# "matplotlib==3.3.2" \
#     "scipy==1.5.3" \
#     "numba==0.52" \
#     "numexpr==2.7.1" \
#     "psycopg2==2.8.6" \
#     "xlrd==1.2" \
#     "pandas==1.1.4" \
#     "ipympl==0.5.8" \


sudo npm install -g configurable-http-proxy -y


sudo mkdir -p /opt/jupyterhub/etc/jupyterhub/
cd /opt/jupyterhub/etc/jupyterhub/
# sudo echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" | sudo tee /etc/apt/sources.list.d/conda.list

# Create the configuration for JupyterHub
# sudo /opt/jupyterhub/bin/jupyterhub --generate-config
echo "Prepare jupyterhub_confug.py"
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/sh/jupyterhub_config.py /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
sudo chmod a+x /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py

# userlist
echo "Prepare userlist"
cd /home/$INSTALL_USER/$PRJ_DIR_NAME/sh
if [[ ! -f userlist ]]; then
    echo "Copying environment template..."
    cp userlist-template userlist
fi
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/sh/userlist /opt/jupyterhub/etc/jupyterhub/userlist


# Part II: Conda Environments
# 安裝使用者環境
# 會將conda安裝在 /opt/conda/; 指令會在 /opt/conda/bin/conda
echo "Setup user environment in Jupyterlab."
sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
sudo mkdir -p /opt/conda/envs/

# Install a default conda environment for all users
sudo /opt/conda/bin/conda install -c conda-forge -y 'conda-build' && \
    sudo /opt/conda/bin/conda config --prepend channels conda-forge

# 建立conda env 同時安裝libraries
# 將jupyterhub內的conda env 放在為jupyterhub安裝的虛擬環境中
sudo /opt/conda/bin/conda create --prefix /opt/conda/envs/python python=3.7 ipykernel 
# 增加jupyter運算核心

sudo /opt/conda/envs/python/bin/python3 -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python 3 (default)"
# 會遇到下列訊息, 日後還有問題有需要可以著手處理
#[InstallIPythonKernelSpecApp] WARNING | Installing to /opt/jupyterhub/share/jupyter/kernels, 
# which is not in ['/root/.local/share/jupyter/kernels', '/opt/conda/envs/python/share/jupyter/kernels', '/usr/local/share/jupyter/kernels', '/usr/share/jupyter/kernels', '/root/.ipython/kernels']. 
# The kernelspec may not be found.
# Installed kernelspec python in /opt/jupyterhub/share/jupyter/kernels/python

# 安裝到使用者的env...但是很像沒有作用
# sudo /opt/conda/bin/conda install -p /opt/jupyterhub/ \
sudo /opt/conda/bin/conda install -p /opt/conda/envs/python \
    -c conda-forge \
    "nodejs>=12.4" \
    "icu==58.2" \
    "python-libarchive-c==2.9" \
    "conda-package-handling" \
    "libarchive==3.5" \
    "ipywidgets==7.5.1" \
    "widgetsnbextension==3.5.1" \
    "matplotlib==3.3.2" \
    "scipy==1.5.3" \
    "numba==0.52" \
    "numexpr==2.7.1" \
    "psycopg2==2.8.6" \
    "xlrd==1.2" \
    "pandas==1.1.4" \
    "ipympl==0.5.8" \
    "nbgitpuller==0.9" \
    "voila==0.2.4" \
    "voila-gridstack==0.0.12" \
    "ipyleaflet==0.13.3" \
    "psutil==5.7.3" \
    "google-cloud-storage" \
    "nose==1.3.7" \
    "scikit-learn==0.23.2" \
    -y 

# "jupyterhub=$JUPYTERHUB_VERSION" \
# "jupyterlab=$JUPYTERLAB_VERSION" \
# "notebook=$NOTEBOOK_VERSION" \
#cv2 not available
sudo /opt/conda/envs/python/bin/python -m pip install --upgrade pip --no-cache-dir 
sudo /opt/conda/envs/python/bin/pip3 install keplergl --no-cache-dir 


sudo chmod -R a+w /opt/conda/ && \
    sudo chown -R root:users /opt/conda && \
    sudo chmod g+s /opt/conda

sudo /opt/conda/bin/conda build purge-all && \
    sudo /opt/conda/bin/conda clean --all -f -y && \
    sudo rm -fvR /opt/conda/pkgs/*

echo "安裝和啟用jupyterlab/jupyter notebook 外掛."
export NODE_OPTIONS=--max-old-space-size=4096 && \
sudo /opt/jupyterhub/bin/jupyter serverextension enable --py jupyterlab --sys-prefix && \
sudo /opt/jupyterhub/bin/jupyter serverextension enable voila --sys-prefix && \
sudo /opt/jupyterhub/bin/jupyter nbextension install --py widgetsnbextension --sys-prefix && \
sudo /opt/jupyterhub/bin/jupyter nbextension enable widgetsnbextension --py --sys-prefix && \
sudo /opt/jupyterhub/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager keplergl-jupyter --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install jupyter-matplotlib --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install jupyterlab_filetree --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install @jupyter-widgets/jupyterlab-sidecar --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install @jupyterlab/geojson-extension --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install spreadsheet-editor --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install @jupyter-voila/jupyterlab-preview --no-build && \
sudo /opt/jupyterhub/bin/jupyter nbextension enable --py --sys-prefix ipyleaflet && \
sudo /opt/jupyterhub/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-leaflet --no-build && \
sudo /opt/jupyterhub/bin/jupyter labextension install jupyterlab_iframe  --no-build && \
sudo /opt/jupyterhub/bin/jupyter serverextension enable --py jupyterlab_iframe && \
sudo /opt/jupyterhub/bin/jupyter lab build --minimize=False && \
unset NODE_OPTIONS 

    # jupyter labextension install jupyterlab-plotly@4.6.0 --no-build && \
    # jupyter labextension install plotlywidget@4.6.0 --no-build && \

# sudo rm -rf /var/lib/apt/lists/*



# # nginx 安裝啟動設定
cd /home/$INSTALL_USER/$PRJ_DIR_NAME/sh
sudo systemctl stop nginx
if [ ! -d /etc/nginx/sites-available/$SITE_DOMAIN ]; then 
    sudo mkdir -p /etc/nginx/sites-available/$SITE_DOMAIN
fi
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/sh/nginx_http.conf /etc/nginx/sites-available/$SITE_DOMAIN/nginx_http.conf
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/sh/htpasswd /etc/nginx/htpasswd
if [ ! -d /etc/ssl/certs ]; then    
    sudo mkdir -p /etc/ssl/certs
fi 
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096

sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/$SITE_DOMAIN/nginx_http.conf /etc/nginx/sites-enabled/$SITE_DOMAIN.conf


sudo /etc/init.d/nginx reload
sudo systemctl stop nginx
sudo systemctl start nginx

# # 設定靜態網頁檔案
if [ ! -d $HTML_DIR ]; then 
    sudo mkdir -p $HTML_DIR
fi    
if [ ! -d $HTML_DIR-bak ]; then 
    sudo mkdir -p $HTML_DIR-bak
fi    

sudo /bin/cp -rf /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/* $HTML_DIR
sudo /bin/cp -rf /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/* $HTML_DIR-bak

echo "共享目錄設定"
sudo groupadd analysts
sudo usermod -aG analysts $USER

# www需要讓特定使用者(如admin group)可以寫入 analysts也可寫入
sudo chown -R root:analysts $HTML_DIR
sudo chmod -R 775 $HTML_DIR
sudo chown -R root:analysts $HTML_DIR-bak
sudo chmod -R 775 $HTML_DIR-bak
cd $HTML_DIR

sudo find . -type d -exec chmod 0755 {} \;
sudo find . -type f -exec chmod 0774 {} \;

cd $HTML_DIR-bak

sudo find . -type d -exec chmod 0755 {} \;
sudo find . -type f -exec chmod 0774 {} \;

# sudo usermod -g analysts $USER
# if [ ! -d /srv/data/share ]; then
#     sudo mkdir -p /srv/data/share
# if
# sudo chown -R root:analysts /srv/data/share
# sudo chmod -R 775 /srv/data/share

## 後面發布時的流程會在處理
# sudo chown -R root:analysts $HTML_DIR
# sudo chmod -R 775 $HTML_DIR

# 新使用者建立時的預設設定 (其他手動建立的行為請見add_user.sh)
cd /home/$INSTALL_USER/$PRJ_DIR_NAME/sh
if [[ -f /etc/default/useradd ]]; then    
    sudo rm /etc/default/useradd
fi 
sudo cp useradd-default-template /etc/default/useradd

# sudo cp ~/.bashrc /etc/skel
# sudo cp ~/.bash_logout /etc/skel
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/sh/etc_skel/.bashrc /etc/skel
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/sh/etc_skel/.bash_logout /etc/skel
sudo chmod +x /etc/skel/*.sh
sudo chmod +x /etc/skel/*.ipynb
sudo chmod +x /etc/skel/my-web/*.ipynb

# setfacl only works in native linux; not working for WSL 
# sudo apt install -y acl
# # Granting permission for a group named "analysts" would look something like this:
# sudo setfacl -R -m d:g:analysts:rwx /srv/data/share
# # 非群組的應該都看不到
# sudo setfacl -R -m d:o::r /srv/data/share
# # 加入權限使預設新建立的檔案都是rwx權限:
# sudo setfacl -R -m d:mask:rwx /srv/data/share

sudo setfacl -R -m d:g:analysts:rwx $HTML_DIR
sudo setfacl -R -m d:g:analysts:rwx $HTML_DIR-bak
# 非群組的應該都看不到
sudo setfacl -R -m d:o::rx $HTML_DIR
sudo setfacl -R -m d:o::rx $HTML_DIR-bak
# 加入權限使預設新建立的檔案都是rx權限:
sudo setfacl -R -m d:mask:r $HTML_DIR
sudo setfacl -R -m d:mask:r $HTML_DIR-bak
# 讓還原www 只能讓預設admin操作
sudo usermod -a -G ssl-cert root

cd /home/$INSTALL_USER

sudo mkdir -p /var/ssl
# ssl_certificate 
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/secrets/certificate.crt /var/ssl/certificate.crt
# ssl_certificate_key 
sudo cp /home/$INSTALL_USER/$PRJ_DIR_NAME/secrets/private.key /var/ssl/private.key
# set permission of private key
# optional, but safer. Private keys then have group ssl-cert, owner root, and permissions 640.
sudo addgroup ssl-cert
# sudo adduser root ssl-cert
sudo usermod -a -G ssl-cert root
sudo chown root:ssl-cert /var/ssl/private.key
sudo chmod 600 /var/ssl/private.key
sudo chown root:ssl-cert /var/ssl/certificate.crt
sudo chmod 644 /var/ssl/certificate.crt

# /usr/local/bin/julia -e 'import Pkg; Pkg.add("IJulia"); Pkg.build("IJulia"); using IJulia; notebook(detached=true);'

# ## install julia
# cd ~
# wget https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.3-linux-x86_64.tar.gz
# tar xvfz julia-1.5.3-linux-x86_64.tar.gz
# sudo chown -R root:users ~/julia-1.5.3/
# # sudo chmod a+x ~/julia-1.5.3/bin/
# # cd /usr/local/bin/
# sudo ln -s ~/julia-1.5.3/bin/julia /usr/local/bin/julia

source ~/.bashrc

cd /home/$USER

# sudo systemctl daemon-reload
# sudo systemctl enable nginx
# sudo systemctl start nginx
# 建立jupyterhub_cookie_secret

cd ~
if [ -f jupyterhub_cookie_secret]; then
    rm jupyterhub_cookie_secret
fi
sudo openssl rand -hex 32 > jupyterhub_cookie_secret
sudo /bin/cp jupyterhub_cookie_secret /srv/jupyterhub/jupyterhub_cookie_secret
sudo chmod 600 /srv/jupyterhub/jupyterhub_cookie_secret

# Setup Systemd service
echo "Setup Jupyterhub systemd service"
sudo mkdir -p /opt/jupyterhub/etc/systemd
sudo /bin/cp /home/$USER/$PRJ_DIR_NAME/sh/jupyterhub.service /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service
sudo chmod a+x /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo systemctl daemon-reload
sudo systemctl enable jupyterhub.service
sudo systemctl start jupyterhub.service

## jupyterlab julia 
# /usr/local/bin/julia -e 'import Pkg; Pkg.add("IJulia"); Pkg.build("IJulia"); using IJulia; notebook(detached=true);'

# ## install julia genie
# /usr/local/bin/julia -e 'import Pkg; Pkg.add("PackageCompiler");using PackageCompiler;Pkg.add("Genie");@time using Genie;@time PackageCompiler.create_sysimage(:Genie; replace_default=true)'

# ## interact.jl
# /usr/local/bin/julia -e 'using Pkg;Pkg.add("Interact");Pkg.add("IJulia");Pkg.add("WebIO")'
# /usr/local/bin/julia -e 'using WebIO; using Interact; WebIO.install_jupyter_labextension();'

# ## deno
# cd ~
# curl -fsSL https://deno.land/x/install/install.sh | sh
# # cd /usr/local/bin/

# ## github
# git config --global user.email "$DEFAULT_GIT_USER_EMAIL"
# git config --global user.name "$DEFAULT_GIT_USER_NAME"
# git config --global credential.helper cache
# git config --global credential.helper store


echo "設定完成!"

source ~/.bashrc