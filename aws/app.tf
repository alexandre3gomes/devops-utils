resource "aws_s3_bucket" "app" {
  bucket_prefix = "finances-app"

  versioning {
    enabled = true
  }

  provisioner "local-exec" {
    command = "aws s3 sync ../../finances-easy-web/dist s3://${self.bucket}"
  }

}

resource "aws_s3_bucket_public_access_block" "app-public-policy" {
  bucket                  = aws_s3_bucket.app.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "cloudfront-access-policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.app-origin-identity.iam_arn]
    }
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.app.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "app-bucket-policy" {
  bucket = aws_s3_bucket.app.id
  policy = data.aws_iam_policy_document.cloudfront-access-policy.json
}

resource "aws_s3_bucket_website_configuration" "app-config" {
  bucket = aws_s3_bucket.app.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

locals {
  s3_origin_id = "finances"
}

resource "aws_cloudfront_origin_access_identity" "app-origin-identity" {
  comment = "Default identity"
}

resource "aws_cloudfront_distribution" "app-distribution" {

  origin {
    domain_name = aws_s3_bucket.app.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app-origin-identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["finances-easy.co.uk"]

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.s3_origin_id
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" //Test other policies
    viewer_protocol_policy   = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.app.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

}

resource "aws_route53_record" "app-record" {
  name    = aws_route53_zone.primary.name
  type    = "A"
  zone_id = aws_route53_zone.primary.zone_id

  alias {
    name                   = aws_cloudfront_distribution.app-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.app-distribution.hosted_zone_id
    evaluate_target_health = false
  }

}