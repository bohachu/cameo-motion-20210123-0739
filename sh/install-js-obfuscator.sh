#!/bin/bash
# for ubuntu/debia/kali
# initial folder = ~/$PRJ_DIR_NAME/sh

source .env

cd ~
echo "安裝npm"
sudo apt install npm
echo "javascript-obfuscator"
sudo npm install --save-dev javascript-obfuscator
if [[ ! -f /usr/local/bin/javascript-obfuscator ]]; then
    sudo ln -s ~/node_modules/javascript-obfuscator/bin/javascript-obfuscator /usr/local/bin
fi

echo "Excample: javascript-obfuscator 檔案名稱.js"

source ~/.bashrc

cd ~/$PRJ_DIR_NAME/sh

