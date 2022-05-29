# Certbot

Install certbot and generate certificate
Domains: finances-easy.com, *.finances-easy.com
https://certbot.eff.org/instructions?ws=haproxy&os=ubuntufocal

sudo certbot -d finances-easy.com --force-renew --manual --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory
sudo certbot -d *.finances-easy.com --force-renew --manual --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory

Generate pem file to haproxy (check the x number in the output of certbot renewal)
`cat /etc/letsencrypt/live/finances-easy.com-000x/fullchain.pem /etc/letsencrypt/live/finances-easy.com-000x/privkey.pem > /etc/ssl/private/finances-easy.com.pem`

