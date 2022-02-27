# Certbot

Install certbot and generate certificate
Domains: finances-easy.com, *.finances-easy.com
https://certbot.eff.org/instructions?ws=haproxy&os=ubuntufocal


Generate pem file to haproxy
`cat /etc/letsencrypt/live/finances-easy.com-0001/fullchain.pem /etc/letsencrypt/live/finances-easy.com-0001/privkey.pem > /etc/ssl/private/finances-easy.com.pem`

