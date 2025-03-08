##################################################################
# AWS WAF - Web Application Firewall Configuration
##################################################################

module "wafv2" {
  source  = "aws-ss/wafv2/aws"
  version = "~> 3.2.0"

  count = var.create_waf ? 1 : 0

  enabled_web_acl_association = true
  resource_arn                = [module.application_alb.arn]

  enabled_logging_configuration = false

  name           = "WebACL01"
  scope          = "REGIONAL"
  default_action = "block"
  rule = [
    {
      name     = "Rule01"
      priority = 10
      action   = "block"
      xss_match_statement = {
        field_to_match = {
          uri_path = {}
        }
        text_transformation = [
          {
            priority = 10
            type     = "NONE"
          }
        ]
      }
      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "cloudwatch_metric_name"
        sampled_requests_enabled   = false
      }
    }
  ]
  visibility_config = {
    cloudwatch_metrics_enabled = false
    metric_name                = "cloudwatch_metric_name"
    sampled_requests_enabled   = false
  }

  tags = local.tags
}
