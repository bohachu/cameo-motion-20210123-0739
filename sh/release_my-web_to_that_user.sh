#!/bin/bash
# for ubuntu/debia/kali
# initial folder: 專案目錄/sh
# 使用情境: 重新佈署既有使用者home資料夾,home/my-web 資料夾

source .env
that_user=$1
echo "重新佈署既有使用者home資料夾,/home/$that_user/ 資料夾..."

# overwrite homepage.html for every user


if [ -d /home/$that_user/my-web ]; then 
    # echo "清除/home/$that_user/my-web/*資料"
    sudo rm -rf /home/$that_user/my-web/*
    echo "清除/home/$that_user/my-web/*完成"
fi

if [ ! -d /home/$that_user/my-web ]; then  
    # echo "建立/home/$that_user/my-web資料夾"
    sudo mkdir -p /home/$that_user/my-web
    echo "建立/home/$that_user/my-web資料夾建立完成"
fi

sudo /bin/cp -Rf /etc/skel/*  /home/$that_user/
echo "複製/home/$that_user 資料夾完成"

echo "重新建立my-web連結"
if [[ ! -d $HTML_DIR/$that_user ]]; then
    sudo ln -s /home/$that_user/my-web $HTML_DIR/$that_user
fi

echo "重新設定/home/$that_user檔案目錄權限"
sudo bash setup_my-web_permission_that_user.sh $that_user
# chown -R $that_user:analysts /home/$that_user/my-web
# cd /home/$that_user/my-web
# sudo find . -type d -exec chmod 0755 {} \;
# sudo find . -type f -exec chmod 0744 {} \;

# sudo chmod +x /home/$that_user/my-web/*.ipynb
chown -R $that_user:analysts /home/$that_user/*.ipynb
sudo chmod +x /home/$that_user/*.ipynb

echo "Deploy /etc/skel to /home/$that_user/ completed."
