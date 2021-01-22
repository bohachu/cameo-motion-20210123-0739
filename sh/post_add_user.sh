#!/bin/bash
# 使用情境: admin透過jupyterhub GUI建立使用者後, 手動處理後續
# 001 建立密碼
# 002 建立預覽連結到網頁相對目錄下
# 用法 ./post_add_user.sh username
# 執行目錄: admin home目錄

source .env

new_user=$1
# 建立一般使用者後, admin使用者須跑兩個動作
# 001 建立密碼
sudo passwd $new_user
# 002 建立預覽連結到網頁相對目錄下
if [[ ! -d $HTML_DIR/$new_user ]]; then
    sudo ln -s /home/$new_user/my-web $HTML_DIR/$new_user
fi

# 003 add the user to analysts
sudo usermod -a -G analysts $new_user

sudo bash setup_my-web_permission_that_user.sh $new_user
# chown -R $new_user:analysts /home/$new_user/my-web

# cd /home/$new_user/my-web
# sudo find . -type d -exec chmod 0755 {} \;
# sudo find . -type f -exec chmod 0744 {} \;

# sudo chmod +x /home/$new_user/my-web/*.ipynb

chown -R $new_user:analysts /home/$new_user/*.ipynb
sudo chmod +x /home/$new_user/*.ipynb

echo "Post add user process completed."
