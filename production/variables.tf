variable "azure_openai_endpoint" {
  description = "(Optional) The Azure OpenAI endpoint"
  type        = string
  sensitive   = true
}

variable "azure_openai_key" {
  description = "(Optional) The Azure OpenAI key"
  type        = string
  sensitive   = true
}


variable "billing_code" {
  description = "The billing code to tag our resources with"
  type        = string
}

variable "fargate_cpu" {
  type    = number
  default = 256
}

variable "fargate_memory" {
  type    = number
  default = 1024
}

variable "google_client_id" {
  description = "(Optional) The Google IDP Client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "(Optional) The Google IDP Client Secret"
  type        = string
  sensitive   = true
}

variable "secret_key_base" {
  description = "(Required) The secret key base for the application"
  type        = string
  sensitive   = true
}
