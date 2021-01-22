#!/bin/bash

new_user=$1

echo "設定/home/$new_user/my-web 權限..."

function setup_my-web_perm() {
    local the_user=$1
    local folderpath=$2
    local folderperm=$3 #0755
    local fileperm=$4 #0744
    sudo chown -R $the_user:analysts $folderpath
    
    cd $folderpath
    sudo find . -type d -exec chmod $folderperm {} \;
    sudo find . -type f -exec chmod $fileperm {} \;

    sudo chmod +x $folderpath/*.ipynb
}
setup_my-web_perm $new_user /home/$new_user/my-web 0755 0744
# sudo chown -R $new_user:analysts /home/$new_user/my-web
# cd /home/$new_user/my-web
# sudo find . -type d -exec chmod 0755 {} \;
# sudo find . -type f -exec chmod 0744 {} \;

# sudo chmod +x /home/$new_user/my-web/*.ipynb
echo "設定/home/$new_user/my-web 權限完成。"