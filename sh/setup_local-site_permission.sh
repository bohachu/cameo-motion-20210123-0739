#!/bin/bash
# 執行目錄: 專案目錄/sh/
source .env

echo "重新設定local site權限"

function setup_folder_perm() {
    local the_user=$1
    local folderpath=$2
    local folderperm=$3 #0775
    local fileperm=$4 #0774
    echo "www需要讓特定使用者(如admin group)可以寫入 analysts也可寫入"
    sudo chown -R root:analysts $folderpath
    sudo chmod -R $folderperm $folderpath

    cd $folderpath

    sudo find . -type d -exec chmod $folderperm {} \;
    sudo find . -type f -exec chmod $fileperm {} \;

    sudo setfacl -R -m d:g:analysts:rwx $folderpath
    echo "非群組的應該都看不到"
    sudo setfacl -R -m d:o::rx $folderpath
    echo "加入權限使預設新建立的檔案都是r權限:"
    sudo setfacl -R -m d:mask:r $folderpath
}

setup_folder_perm root $HTML_DIR 0775 0774
setup_folder_perm root $HTML_DIR-bak 0775 0774

echo "重新設定local site權限 作業完成。"