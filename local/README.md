
# Generate a unique private key (KEY)
sudo openssl genrsa -out mydomain.key 2048

# Generating a Certificate Signing Request (CSR)
sudo openssl req -new -key mydomain.key -out mydomain.csr

# Creating a Self-Signed Certificate (CRT)
openssl x509 -req -days 365 -in mydomain.csr -signkey mydomain.key -out mydomain.crt

# Append KEY and CRT to mydomain.pem
sudo bash -c 'cat mydomain.key mydomain.crt >> /etc/ssl/private/mydomain.pem'

# Specify PEM in haproxy config
sudo vim /etc/haproxy/haproxy.cfg
listen haproxy
  bind 0.0.0.0:443 ssl crt /etc/ssl/private/mydomain.pem