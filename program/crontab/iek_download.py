# -*- coding: utf-8 -*
import requests
from datetime import date
import urllib.request
import pandas

today = date.today()
date_time = today.strftime("%Y%m%d")

filename = date_time + "_iek_data.csv"

print("start downloading")

try:
  urllib.request.urlretrieve("http://mopsfin.twse.com.tw/opendata/t187ap05_L.csv", filename)
except:
  print("An exception occurred")

print("Downloaded. Saved to "+filename)

df = pandas.read_csv(filename)       
print(df)

test=df[df["產業別"]=="半導體業"]
print(test)

top_company_data =df[df["產業別"]=="半導體業"].sort_values(by=['營業收入-當月營收'],ascending=False)[['公司代號','公司名稱','營業收入-當月營收']].head(10)

result=top_company_data.sort_values(by=['營業收入-當月營收'],ascending=False)

print(result)

result.to_csv('/var/www/iek.cameo.tw/html/app-cameo-rank/data/data.csv', index=False)



 
