# Finances Easy Devops
This project contains utils files to build a kubernetes infrastructure and manifests of finances micro services, nginx ingress controller and prometheus monitoring

## Terraform deployment ##

Deploy hosted zone:
````
terraform apply --target aws_route53_zone.primary -auto-approve
````

Restore dump file:

pg_restore -h finances-db.ctr31f82yt32.eu-west-1.rds.amazonaws.com -d finances -U BA6MygjngR8p7Xfz -v -O -a latest.dump