terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.22.0"
    }
  }
}

provider "aws"{
  region = "us-east-2"
}

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my-anime-quotes-api"
  description = "My Anime Quotes API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

module "naruto" {
  source           = "./modules/api_gateway_get_resource"
  anime_name       = "naruto"
  rest_api_id      = aws_api_gateway_rest_api.my_api.id
  root_resource_id = aws_api_gateway_rest_api.my_api.root_resource_id
}

module "inuyasha" {
  source           = "./modules/api_gateway_get_resource"
  anime_name       = "inuyasha"
  rest_api_id      = aws_api_gateway_rest_api.my_api.id
  root_resource_id = aws_api_gateway_rest_api.my_api.root_resource_id
}

resource "aws_api_gateway_deployment" "deployment_api" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      module.naruto.aws_api_gateway_resource_id,
      module.naruto.aws_api_gateway_method_id,
      module.naruto.aws_api_gateway_integration_id,
      module.naruto.aws_api_gateway_method_response_id,
      module.naruto.aws_api_gateway_integration_response_id,

      module.inuyasha.aws_api_gateway_resource_id,
      module.inuyasha.aws_api_gateway_method_id,
      module.inuyasha.aws_api_gateway_integration_id,
      module.inuyasha.aws_api_gateway_method_response_id,
      module.inuyasha.aws_api_gateway_integration_response_id
    ]))
  }
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage_api" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "anime"
  deployment_id = aws_api_gateway_deployment.deployment_api.id
  description   = "anime"
}

resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = aws_api_gateway_stage.stage_api.stage_name
  method_path = "*/*"

  settings {
    caching_enabled        = false 
    cache_ttl_in_seconds   = 120
    metrics_enabled        = true
    logging_level          = "INFO"
  }
}