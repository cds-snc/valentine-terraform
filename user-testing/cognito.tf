resource "aws_cognito_user_pool" "valentine_user_pool" {
  name = "valentine-user-pool"

  username_attributes = ["email"]

  user_pool_tier = "LITE"
}


resource "aws_cognito_user_pool_client" "client" {
  name = "valentine-client"

  user_pool_id = aws_cognito_user_pool.valentine_user_pool.id

  generate_secret                      = true
  callback_urls                        = ["https://${aws_acm_certificate.valentine.domain_name}/auth/cognito/callback"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "valentine-auth"
  user_pool_id = aws_cognito_user_pool.valentine_user_pool.id
}
