#!/bin/bash
# for ubuntu/debia/kali
# initial folder: 專案目錄/sh
# 使用情境: 將專案目錄中的發布檔案,放置至使用者建立模板my-web資料夾中

source .env
cd ..

# 處理新使用者建立時行為
echo "設定增加使用者時的行為, 預設目錄和設定檔..."


if [ ! -d /etc/skel/history ]; then  
    sudo mkdir -p /etc/skel/history
fi

# overwrite homepage.html for every user


if [ ! -d /etc/skel/my-web ]; then  
    sudo mkdir -p /etc/skel/my-web
fi
sudo /bin/cp -Rf dist/* /etc/skel/my-web/

if [[ -f /etc/skel/homepage.html ]]; then
    sudo rm /etc/skel/homepage.html
fi
sudo /bin/cp homepage.html /etc/skel/my-web

# cp those ipynb and components
# sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/get_iframe.ipynb /etc/skel/my-web/
# sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/fork_component.ipynb /etc/skel/my-web/
# sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/get_preview_address.ipynb /etc/skel/my-web/

# 將fork 與 iframe功能複製到預設使用者目錄中
function cp_file_to_etcskel() {
    local filename=$1
    local file_dest_folder=$2 
    if [[ ! -f /home/$new_user/$filename ]]; then
        # /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/$filename /etc/skel/$filename 
        sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/$filename $file_dest_folder/$filename
    fi
}

List=( "get-myweb-iframe.ipynb" "get-iframe.ipynb" "fork-component.ipynb" "get-preview-address.ipynb" )


for Item in ${List[*]} 
  do
    echo "cp_file_to_etcskel /home/$INSTALL_USER/$PRJ_DIR_NAME/program/$Item /etc/skel/my-web/$Item"
    cp_file_to_etcskel $Item "/etc/skel/my-web"
  done

sudo /bin/cp /home/$INSTALL_USER/$PRJ_DIR_NAME/program/ipynb/settings.ipynb /etc/skel/


if [ ! -d /etc/skel/my-web/components ]; then  
    sudo mkdir -p /etc/skel/my-web/components
fi

sudo /bin/cp -Rf /home/$INSTALL_USER/$PRJ_DIR_NAME/components/* /etc/skel/my-web/components/

sudo chown -R root:root /etc/skel
sudo chown -R :analysts /etc/skel/my-web
sudo chmod +x /etc/skel/my-web/*.ipynb
sudo chmod +x /etc/skel/*.ipynb

echo "Deploy dist to /etc/skel completed."
