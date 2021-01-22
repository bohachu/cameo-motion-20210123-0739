#!/bin/bash
# for ubuntu/debia/kali
# initial folder: 專案目錄/sh
cd ..

function obs_js_2_dist() {
    javascript-obfuscator $1/"$1.js"
    mkdir -p dist/$1
    cp $1/"$1-obfuscated.js" dist/$1/"$1.js"
    rm $1/"$1-obfuscated.js"
}

obs_js_2_dist cameo-divergent-stacked-bars
obs_js_2_dist cameo-run
obs_js_2_dist cameo-line
obs_js_2_dist cameo-rank
obs_js_2_dist cameo-multi-axis-prediction
obs_js_2_dist cameo-map-tw

