#!/bin/sh
openssl pkcs12 -export -in $HOME/desenv/data/cert/api.finances-easy.com/certificate.crt -inkey /$HOME/desenv/data/cert/api.finances-easy.com//private.key -name finances-easy -out $HOME/desenv/data/cert/api.finances-easy.com/finances-easy_com.p12
keytool -importkeystore -deststorepass 123456 -destkeystore $HOME/desenv/data/cert/api.finances-easy.com/finances-easy_com.jks -srckeystore $HOME/desenv/data/cert/api.finances-easy.com/finances-easy_com.p12 -srcstoretype PKCS12
cp $HOME/desenv/data/cert/api.finances-easy.com/finances-easy_com.p12 $HOME/desenv/projects/personal/finances-easy/finances-easy-api/src/main/resources/cert