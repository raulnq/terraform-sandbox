resource "aws_api_gateway_resource" "anime_resource" {
  rest_api_id = var.rest_api_id
  parent_id   = var.root_resource_id
  path_part   = var.anime_name
}

resource "aws_api_gateway_method" "anime_resource_get_method" {
  rest_api_id      = var.rest_api_id
  resource_id      = aws_api_gateway_resource.anime_resource.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "anime_resource_get_method_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.anime_resource.id
  http_method             = aws_api_gateway_method.anime_resource_get_method.http_method
  type                    = "HTTP"
  uri                     = "https://animechan.vercel.app/api/quotes/anime?title=${var.anime_name}"
  integration_http_method = aws_api_gateway_method.anime_resource_get_method.http_method
}

resource "aws_api_gateway_method_response" "anime_200_method_response" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.anime_resource.id
  http_method = aws_api_gateway_method.anime_resource_get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "anime_200_integration_response" {
  rest_api_id       = var.rest_api_id
  resource_id       = aws_api_gateway_resource.anime_resource.id
  http_method       = aws_api_gateway_method.anime_resource_get_method.http_method
  status_code       = aws_api_gateway_method_response.anime_200_method_response.status_code
  selection_pattern = "2\\d{2}"
}