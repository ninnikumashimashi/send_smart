#!/bin/bash

readonly DISK_INFO="/proc/scsi/scsi"
readonly SMART_DIR="/tmp/smart/*"
readonly DISK_USAGE="/dev/mapper"

readonly MAIL_SUBJECT="${HOSTNAME} S.M.A.R.T. info"
readonly MAIL_TO="youraddress@gmail.com"
readonly MAIL_FROM="${HOSTNAME}@example.com"
readonly MAIL_CONTENT="text/html; charset=UTF-8"

readonly HTML_TEMPLATE=$(cd $(dirname $0);pwd)/base.html
readonly TABLE_HEADER="<table><tr><th>ID</th><th>説明</th><th>値</th><th>ワースト値</th><th>しきい値</th><th>Raw値</th><th>ステータス</th></tr>"


get_disk_usage(){
    # $5はdf -hでの表示順に依るため、順番変わったら変更必要あり
    usage=(`df -h | grep ^$DISK_USAGE | awk '{print $5}'`)
    echo "<h3>"$DISK_USAGE "使用率："$usage"</h3>"
}


get_disk_models(){
    cnt=0
    while read line; do
        # Model記載の行だけ抜き出し
        if [[ $line == *Model* ]]; then
            cnt=$((++cnt))
            echo "<h4>"Disk$cnt:${line}"</h4>"
        fi
    done <$DISK_INFO
}


get_smart_info(){
    for file in $SMART_DIR; do
        cnt=0
        smart=""
        # 拡張子がinfoのファイルだけ読み込み
        if [[ ${file##*.} == "info" ]]; then
            while read line; do
                # ループ1回目はヘッダ、2回目以降はカンマ区切りを<td>タグに置換
                if [ $cnt -eq 0 ]; then
                    smart=${TABLE_HEADER}
                else
                    smart=${smart}"<tr><td>${line//,/</td><td>}</td></tr>"
                fi
                cnt=$((++cnt))
            done <$file
        fi
        echo $smart"</table>"
    done
}


build_mail_body(){
    echo $(get_disk_usage)
    # 文字列中にスペースがあると配列になっちゃってうまく行かないのを回避(よくわかっていない)
    IFS_bak=$IFS
    IFS=$'\n'
    disk_models=(`get_disk_models`)
    IFS=$IFS_bak
    smart_info=(`get_smart_info`)

    for((i=0; i<${#disk_models[@]}; ++i)); do
        echo "${disk_models[$i]}"
        echo "${smart_info[$i]}"
    done
}


replace_html(){
    body=$(build_mail_body)
    # base.html中の文字列をtableに置換
    while read line; do
        if [[ $line == *{insert_smart_info}* ]]; then
            echo ${line/"{insert_smart_info}"/$body}
        else
            echo $line
        fi
    done <$HTML_TEMPLATE
}


send_smart_mail(){
    mail_all="Subject: "$MAIL_SUBJECT$'\n'"To: "$MAIL_TO$'\n'"From: "$MAIL_FROM$'\n'"Content-type: "$MAIL_CONTENT$'\n'$'\n'$(replace_html)
    echo "$mail_all" | ssmtp $MAIL_TO
}

send_smart_mail
