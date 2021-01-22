#!/bin/bash
# for ubuntu/debia/kali
# initial folder: 專案目錄/sh
# 不包含 components內的東西
# 複製到 dist/
source .env


lib_version=$JS_LIB_VERSION

# 回到專案目錄
cd /home/$INSTALL_USER/$PRJ_DIR_NAME
echo $PWD
if [[ -d /home/$INSTALL_USER/$PRJ_DIR_NAME/dist ]]; then
    rm -rf /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/*
fi

if [[ ! -d /home/$INSTALL_USER/$PRJ_DIR_NAME/dist ]]; then
    mkdir /home/$INSTALL_USER/$PRJ_DIR_NAME/dist
fi
if [[ ! -d /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version ]]; then
    mkdir -p /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version
fi

cp -R /home/$INSTALL_USER/$PRJ_DIR_NAME/lib/ /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
cp -R /home/$INSTALL_USER/$PRJ_DIR_NAME/app-* /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
# cp -R cameo-* dist/
echo "Copied app-* and cameo-* modules to dist."
cp -R img /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
cp -R scss /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
echo "Copied img and scss folder."
cp /home/$INSTALL_USER/$PRJ_DIR_NAME/iek-carousel.html /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
cp /home/$INSTALL_USER/$PRJ_DIR_NAME/index.html /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
cp /home/$INSTALL_USER/$PRJ_DIR_NAME/favicon.ico /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/
echo "Copied favicon.ico and *.html."

function compile_module() {
    local module_path=$1
    local js_name=$2
    echo "Compiling module_path: $module_path"
    javascript-obfuscator "$module_path/$js_name.js"
    rm "$module_path/$js_name.js"
    /bin/cp "$module_path/$js_name-obfuscated.js" "$module_path/$js_name.js"
    rm "$module_path/$js_name-obfuscated.js"
    echo "Compiled js: $module_path/$js_name.js ."
}
# echo "compile_module dist/lib/$lib_version/cameo-core cameo-df"
compile_module "/home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version/cameo-core" "cameo-df"
# echo "compile_module /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version/cameo-core cameo-load"
compile_module "/home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version/cameo-core" "cameo-load"
# echo "compile_module /home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version/cameo-motion/cameo-table cameo-table" 
compile_module "/home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version/cameo-motion/cameo-table" "cameo-table"


List=( "cameo-divergent-stacked-bars" "cameo-line" "cameo-map-tw" "cameo-multi-axis-prediction" "cameo-rank" "cameo-run" )

for Item in ${List[*]} 
  do
    # echo "compile_module dist/lib/$lib_version/$Item $Item"
    compile_module "/home/$INSTALL_USER/$PRJ_DIR_NAME/dist/lib/$lib_version/$Item" $Item
  done


echo "JS Compiled in folder dist"

