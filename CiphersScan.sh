#this script doing grep to txt of cipher url

for DNS in $(cat /home/appsec/domain.list)
do
        echo $DNS
        nmap -oN /home/appsec/sites/$DNS -p 443 --script ssl-enum-ciphers.nse $DNS
done
files=/home/appsec/sites/*
for url in $files
do
        input=$url
        filename=${url##*/}
        while IFS= read -r line
        do
                temp=$(echo "$line" | grep -oE 'TLSv1.+|SSLv3' | sed 's/://' | sed 's/^[\t]*//')
                if [ -n "$temp" ]
                then
                        title=$(echo "$line" | grep -oE 'TLSv1.+|SSLv3' | sed 's/://' | sed 's/^[\t]*//')
                fi
                cipher=$(echo "$line" | grep -oE 'TLS_.+' | sed 's/^[\t]*//')
                if [ -n "$cipher" ]
                then
                                echo $filename $title $cipher >> /home/appsec/nmap/results.nmap
                fi
        done <"$input"|sed -r '/^\s*$/d'
done