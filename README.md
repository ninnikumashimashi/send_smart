# send_smart
QNAPのNASから、ディスク使用率とS.M.A.R.T.情報をhtmlメールで送信します。  
わたしが持っているTS-231P(ファームウェア：4.3.6.0895)では動いていますが、  
このほかのモデルでは動くかわかりません。  
あと、Gmailでしかやってみていません。

### 送信者情報の追記
/etc/config/ssmtp/ssmtp.confに、送信元メールアドレスの情報の記載が必要です。  
例)
>mailhub=smtp.gmail.com:587  
>UseSTARTTLS=yes  
>AuthUser=youraddress@gmail.com  
>enAuthPass = yourpassword  

### Disk情報
/proc/scsi/scsi
の、「Model」が入った行を引っ張ってきています。  
別のモデルやファームウェアのNASでは、ディレクトリ構成が変わっているかもしれないので  
適宜変更ください。

### S.M.A.R.T.情報
/tmp/smart/  
に、smart_0_\*.infoというファイルがあります。  
※\*部分は数字。ディスクの数だけファイルがある(たぶん)。  

TS-231Pは2ディスクのモデルですが、ここにディスクの分だけinfoファイルが  
作られていれば、搭載ディスクの多いモデルでもたぶん大丈夫だと思います。

### 使用率取得
df -hで、/dev/mapper箇所の使用率を取得してきています。  
データ領域の作り方(?)とかで変わってくるかもしれないので、こちらも適宜変更ください。

### 取得した情報をhtmlに挿入(置換)
あとは取得した情報たちを、base.htmlの{insert_smart_info}に挿入(置換)するだけです。

### cronなどで実行
base.htmlとsend_smart.shを適当なところに保存して(同一ディレクトリ)、  
send_smart.shをcronとかで定期実行してあげれば  
きっとそれっぽくなると思います。

### メール文面サンプル
<h3>/dev/sda1 使用率：2%</h3> <h4>Disk1: Vendor: WDC Model: ********-******** Rev: **.*</h4> <table><tr><th>ID</th><th>説明</th><th>値</th><th>ワースト値</th><th>しきい値</th><th>Raw値</th><th>ステータス</th></tr><tr><td>1</td><td>Raw_Read_Error_Rate</td><td>200</td><td>200</td><td>51</td><td>0</td><td>0</td></tr><tr><td>3</td><td>Spin_Up_Time</td><td>178</td><td>171</td><td>21</td><td>6075</td><td>0</td></tr><tr><td>4</td><td>Start_Stop_Count</td><td>100</td><td>100</td><td>0</td><td>441</td><td>0</td></tr><tr><td>5</td><td>Retired_Block_Count</td><td>200</td><td>200</td><td>140</td><td>0</td><td>0</td></tr><tr><td>7</td><td>Seek_Error_Rate</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr><tr><td>9</td><td>Power-On_Hours</td><td>67</td><td>67</td><td>0</td><td>24521</td><td>0</td></tr><tr><td>10</td><td>Spin_Retry_Count</td><td>100</td><td>100</td><td>0</td><td>0</td><td>0</td></tr><tr><td>11</td><td>Calibration_Retry_Count</td><td>100</td><td>100</td><td>0</td><td>0</td><td>0</td></tr><tr><td>12</td><td>Power_Cycle_Count</td><td>100</td><td>100</td><td>0</td><td>364</td><td>0</td></tr><tr><td>192</td><td>Power-Off_Retract_Count</td><td>200</td><td>200</td><td>0</td><td>19</td><td>0</td></tr><tr><td>193</td><td>Load_Cycle_Count</td><td>200</td><td>200</td><td>0</td><td>421</td><td>0</td></tr><tr><td>194</td><td>Temperature_Celsius</td><td>112</td><td>105</td><td>0</td><td>38</td><td>0</td></tr><tr><td>196</td><td>Reallocated_Event_Count</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr><tr><td>197</td><td>Current_Pending_Sector</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr><tr><td>198</td><td>Uncorrectable_Sector_Count</td><td>100</td><td>253</td><td>0</td><td>0</td><td>0</td></tr><tr><td>199</td><td>SATA_R-Error_Count</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr></table> <h4>Disk2: Vendor: WDC Model: ********-******** Rev: **.*</h4> <table><tr><th>ID</th><th>説明</th><th>値</th><th>ワースト値</th><th>しきい値</th><th>Raw値</th><th>ステータス</th></tr><tr><td>1</td><td>Raw_Read_Error_Rate</td><td>200</td><td>200</td><td>51</td><td>0</td><td>0</td></tr><tr><td>3</td><td>Spin_Up_Time</td><td>176</td><td>169</td><td>21</td><td>6191</td><td>0</td></tr><tr><td>4</td><td>Start_Stop_Count</td><td>100</td><td>100</td><td>0</td><td>404</td><td>0</td></tr><tr><td>5</td><td>Retired_Block_Count</td><td>200</td><td>200</td><td>140</td><td>0</td><td>0</td></tr><tr><td>7</td><td>Seek_Error_Rate</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr><tr><td>9</td><td>Power-On_Hours</td><td>85</td><td>85</td><td>0</td><td>11212</td><td>0</td></tr><tr><td>10</td><td>Spin_Retry_Count</td><td>100</td><td>100</td><td>0</td><td>0</td><td>0</td></tr><tr><td>11</td><td>Calibration_Retry_Count</td><td>100</td><td>100</td><td>0</td><td>0</td><td>0</td></tr><tr><td>12</td><td>Power_Cycle_Count</td><td>100</td><td>100</td><td>0</td><td>330</td><td>0</td></tr><tr><td>192</td><td>Power-Off_Retract_Count</td><td>200</td><td>200</td><td>0</td><td>9</td><td>0</td></tr><tr><td>193</td><td>Load_Cycle_Count</td><td>190</td><td>190</td><td>0</td><td>30021</td><td>0</td></tr><tr><td>194</td><td>Temperature_Celsius</td><td>115</td><td>109</td><td>0</td><td>35</td><td>0</td></tr><tr><td>196</td><td>Reallocated_Event_Count</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr><tr><td>197</td><td>Current_Pending_Sector</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr><tr><td>198</td><td>Uncorrectable_Sector_Count</td><td>100</td><td>253</td><td>0</td><td>0</td><td>0</td></tr><tr><td>199</td><td>SATA_R-Error_Count</td><td>200</td><td>200</td><td>0</td><td>0</td><td>0</td></tr></table>
