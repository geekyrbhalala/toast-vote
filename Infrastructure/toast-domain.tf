resource "aws_route53_record" "api_A_record" {
  zone_id = data.aws_route53_zone.geekyrbhalala.zone_id
  name    = "api"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api_domain.regional_domain_name
    zone_id                = "Z19DQILCV0OWEC"
    evaluate_target_health = true
  }

  depends_on = [aws_api_gateway_domain_name.api_domain]
}