resource "aws_default_vpc" "primary" {
}

resource "aws_security_group" "api-sg" {
  name   = "api-security-group"
  vpc_id = aws_default_vpc.primary.id

  ingress {
    cidr_blocks = [aws_default_vpc.primary.cidr_block]
    description = "HTTP"
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
  }
}


resource "aws_security_group" "db-sg" {
  name   = "db-security-group"
  vpc_id = aws_default_vpc.primary.id

  ingress {
    cidr_blocks = [aws_default_vpc.primary.cidr_block]
    description = "POSTGRES"
    from_port   = 5432
    protocol    = "TCP"
    to_port     = 5432
  }
}

resource "aws_route53_zone" "primary" {
  name = "finances-easy.co.uk"
}
resource "aws_acm_certificate" "app" {
  provider          = aws.us_east_1
  domain_name       = "finances-easy.co.uk"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "api" {
  domain_name       = "api.finances-easy.co.uk"
  validation_method = "DNS"
}

resource "aws_route53_record" "app_validation" {
  provider = aws.us_east_1
  for_each = {
    for dvo in aws_acm_certificate.app.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}