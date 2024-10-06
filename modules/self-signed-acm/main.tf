##################################################################
# Self Signed Certificate with ACM
##################################################################

resource "tls_private_key" "this" {
    count = var.create_certificate ? 1 : 0
    algorithm = "RSA"
}

resource "tls_self_signed_cert" "this" {
  
  count = var.create_certificate ? 1 : 0

  private_key_pem = tls_private_key.this[0].private_key_pem

  subject {
    common_name  = var.domain_name
    organization = var.organization
  }

  validity_period_hours = 8766 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "this" {
  count = var.create_certificate ? 1 : 0

  private_key      = tls_private_key.this[0].private_key_pem
  certificate_body = tls_self_signed_cert.this[0].cert_pem
}
