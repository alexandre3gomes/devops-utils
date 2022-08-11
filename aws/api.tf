variable "okta_client_id" {
  type        = string
  description = "Client id of Okta application oauth authentication"
}

variable "okta_client_secret" {
  type        = string
  description = "Client secret of Okta application oauth authentication"
  sensitive   = true
}

variable "api_jar_name" {
  type        = string
  description = "Name of the api jar"
}

resource "aws_s3_bucket" "artificats" {
  bucket_prefix = "artificats"

  provisioner "local-exec" {
    command = "aws s3 cp ../../finances-easy-api/build/libs/${var.api_jar_name} s3://${self.bucket}"
  }
}
resource "aws_s3_bucket_public_access_block" "artifacts-public-policy" {
  bucket                  = aws_s3_bucket.artificats.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "policy_service_allow" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["elasticbeanstalk"]
    }

    principals {
      identifiers = ["elasticbeanstalk.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "application-service-role" {
  name                = "aws-elasticbeanstalk-service-role"
  assume_role_policy  = data.aws_iam_policy_document.policy_service_allow.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth", "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"]
}

resource "aws_elastic_beanstalk_application" "api" {
  name        = "finances-easy-api"
  description = "An API to provide backend for Finances Easy Application"

  appversion_lifecycle {
    service_role          = aws_iam_role.application-service-role.arn
    max_count             = 3
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_application_version" "api-source" {
  name        = "finances-easy-api"
  application = aws_elastic_beanstalk_application.api.name
  bucket      = aws_s3_bucket.artificats.id
  key         = "finances-easy-api.jar"
}

data "aws_iam_policy_document" "policy_ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "beanstalk-role" {
  name                = "aws-elasticbeanstalk-ec2-role"
  assume_role_policy  = data.aws_iam_policy_document.policy_ec2_assume.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier", "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker", "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"]
}

resource "aws_iam_instance_profile" "beanstalk-instance-profile" {
  name = "aws-elasticbeanstalk-instance-profile"
  role = aws_iam_role.beanstalk-role.name
}

resource "aws_elastic_beanstalk_environment" "api-env" {
  name                = "finances-easy-api"
  application         = aws_elastic_beanstalk_application.api.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.1 running Corretto 17"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk-instance-profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.api-sg.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/actuator/health"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = 8089
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "OKTA_CLIENT_ID"
    value     = var.okta_client_id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "OKTA_CLIENT_SECRET"
    value     = var.okta_client_secret
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_URL"
    value     = "jdbc:postgresql://${aws_db_instance.finances-rds.endpoint}/${aws_db_instance.finances-rds.db_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_USER"
    value     = aws_db_instance.finances-rds.username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "POSTGRES_PASSWORD"
    value     = aws_db_instance.finances-rds.password
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"

  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = "true"
  }
  provisioner "local-exec" {
    command = "aws elasticbeanstalk update-environment --environment-name ${self.name} --version-label ${aws_elastic_beanstalk_application_version.api-source.name}"
  }
}
resource "aws_apigatewayv2_api" "finances-api" {
  name          = "finances-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_domain_name" "finances-domain" {
  domain_name = "api.finances-easy.co.uk"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "api-record" {
  name    = aws_apigatewayv2_domain_name.finances-domain.domain_name
  type    = "A"
  zone_id = aws_route53_zone.primary.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.finances-domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.finances-domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_stage" "api-stage" {
  api_id = aws_apigatewayv2_api.finances-api.id
  name   = "prod"
}

resource "aws_apigatewayv2_api_mapping" "finances-mapping" {
  api_id      = aws_apigatewayv2_api.finances-api.id
  domain_name = aws_apigatewayv2_domain_name.finances-domain.id
  stage       = aws_apigatewayv2_stage.api-stage.id
}

resource "aws_apigatewayv2_integration" "api-integration" {
  api_id             = aws_apigatewayv2_api.finances-api.id
  integration_uri    = "http://${aws_elastic_beanstalk_environment.api-env.cname}"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "default-route" {
  api_id    = aws_apigatewayv2_api.finances-api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.api-integration.id}"
}