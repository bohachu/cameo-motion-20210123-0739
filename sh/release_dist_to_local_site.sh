#!/bin/bash
# for ubuntu/debia/kali
# initial folder: 專案目錄/sh
# 重新打包dist之後, 可執行此程式將檔案複製到HTML_DIR
# cp to $HTML_DIR, default to /var/www/iek.cameo.tw/html

source .env
cd /home/$INSTALL_USER/$PRJ_DIR_NAME

function release_dist_to_folder() {
    local folderpath=$1
    echo "複製到HTML_DIR"
    if [ ! -d $folderpath ]; then  
        sudo mkdir -p $folderpath
    fi
    sudo /bin/cp -Rf /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/* $folderpath
    sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/get-www-iframe.ipynb $folderpath/get-www-iframe.ipynb    
}
release_dist_to_folder $HTML_DIR
release_dist_to_folder $HTML_DIR-bak
# echo "複製到HTML_DIR"
# if [ ! -d $HTML_DIR ]; then  
#     sudo mkdir -p $HTML_DIR
# fi
# sudo /bin/cp -Rf dist/* $HTML_DIR
# sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/get-www-iframe.ipynb $HTML_DIR/get-www-iframe.ipynb

# echo "複製到html-bak"
# if [ ! -d $HTML_DIR-bak ]; then  
#     sudo mkdir -p $HTML_DIR-bak
# fi
# sudo /bin/cp -Rf dist/* $HTML_DIR-bak
# sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/get-www-iframe.ipynb $HTML_DIR-bak/get-www-iframe.ipynb

echo "add group analysts"
sudo groupadd analysts

#"重新設定local site權限"
cd sh
sudo bash setup_local-site_permission.sh

echo "Release dist to local site and bak completed."
