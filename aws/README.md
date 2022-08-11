### Terraform files ###

##### There are 5 different files specifying resources for some services: #####

- [main.tf](main.tf): Terraform and provider configurations and variables declaration.
- [network.tf](network.tf): VPC, security groups, hosted zone, certificates and dns records.
- [database.tf](database.tf): Database instance resource.
- [api.tf](api.tf): Buckets, policies, roles, beanstalk resources, dns records and api gateway.
- [app.tf](app.tf): Buckets, policies, dns records and cloudfront.

Variables are stored in terraform cloud workspace.
