#!/bin/bash

echo "執行目錄應為 專案目錄/sh ; 開始進行打包dist 並佈署到對應目錄工作:"

echo "將網站打包到dist: 包含js加密和打包, 產出的網站檔案在dist"
bash ./compile.sh
echo "Compile完成。"

echo "發佈到網站目錄..."
sudo bash release_dist_to_local_site.sh
echo "發佈到網站目錄完成。"

echo "發佈到預設使用者目錄..."
sudo bash release_dist_to_my-web.sh
echo "發佈到預設使用者目錄完成。"

echo "重新佈署完成, 請手動更新既有使用者目錄中的檔案"
