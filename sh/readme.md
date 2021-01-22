# 安裝
### 001 取得git repo
cd 家目錄
git clone <repo網址> 

### 002 準備SSL憑證
將private key和public key,和crt憑證 放置到專案目錄/secrets 目錄 下面

### 003 準備env檔案
第一次佈署可以不用執行此步驟

若不是第一次佈署, 建議人工檢查

cd sh

建立server環境設定檔, 如果不是第一次佈署, 需要檢查現有的.env是否所有key都一樣
cp .env-template .env

建立使用者加目錄中的環境設定檔(因為ipynb需要用到)
cp etc_skel/.user-env-template etc_skel/.user-env
修改.env and .user-env檔案以符合情境


### 004 打包dist 並佈署到對應目錄
將網站發布到wwwhtml目錄中

cd 專案目錄/sh 
安裝js-obfuscator
./install-js-obfuscator.sh

若修改程式碼後重新佈署時, compile以及發布www 和myweb要同時執行, 可執行:
./compile_and_release.sh 

若compile, 以及發布www 和myweb需要獨立執行
compile dist, 包含js加密和打包, 產出的網站檔案在dist
./compile.sh

發佈到網站目錄
./release_dist_to_local_site.sh

發佈到預設使用者目錄
./release_dist_to_my-web.sh

### 005 若重新佈署,既有使用者須轉移進新的檔案
./release_my-web_to_that_user.sh

### 005 安裝jupyterhub, jupyterlab, extension等主程式
第一次安裝server時需要安裝

cd 專案目錄/sh 
./install_server.sh

### 006 建立第一位jupyterhub admin帳號
有兩種方法:

透過jupyterhub 介面建立使用者後
sudo ./post_add_admin_user.sh <username>

不透過jupyterhub 介面
sudo ./add_admin_user.sh <username>

說明:建立時OS會自動 從/etc/skel當作模板copy到此新增使用者加目錄
以及將必要的sh和program內的ipynb 複製過去使用者加目錄
然後設定好權限, 並且預設密碼與帳號一樣



### 007 建立一般使用者
有兩種方法:

透過jupyterhub 介面建立使用者後
sudo ./post_add_user.sh <username>

不透過jupyterhub 介面
sudo ./add_user.sh <username>

### 008 密碼操作
設定個別使用者密碼:
sudo passwd <username>

使用者自行改密碼
passwd <username>

### 009 其他要建立使用者家目錄中的檔案
可以copy進 /etc/skel
在add_user/post_add_user 等過程會處理

# 將Javascript 亂碼與壓縮說明
### 打包 js 
cd sh 
./compile-js.sh

操作紀錄見
https://www.notion.so/javascript-obfuscate-6cb870a822924c3bb59db57f09b8a693


## reference 
[https://miloserdov.org/?p=4767](https://miloserdov.org/?p=4767)

