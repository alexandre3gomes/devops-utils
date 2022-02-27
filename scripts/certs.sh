#!/bin/sh
## Old multiple certificates (certbot apt)
cat /etc/letsencrypt/live/finances-easy.com/fullchain.pem /etc/letsencrypt/live/finances-easy.com/privkey.pem > /etc/ssl/private/sub-finances-easy.com.pem
cat /etc/letsencrypt/live/finances-easy.com-0001/fullchain.pem /etc/letsencrypt/live/finances-easy.com-0001/privkey.pem > /etc/ssl/private/root-finances-easy.com.pem

## New one certifcate (certbot snap)
cat /etc/letsencrypt/live/finances-easy.com-0001/fullchain.pem /etc/letsencrypt/live/finances-easy.com-0001/privkey.pem > /etc/ssl/private/finances-easy.com.pem

docker restart haproxy