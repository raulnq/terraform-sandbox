output "aws_api_gateway_resource_id" {
  value       = aws_api_gateway_resource.anime_resource.id
}

output "aws_api_gateway_method_id" {
  value       = aws_api_gateway_method.anime_resource_get_method.id
}

output "aws_api_gateway_integration_id" {
  value       = aws_api_gateway_integration.anime_resource_get_method_integration.id
}

output "aws_api_gateway_method_response_id" {
  value       = aws_api_gateway_method_response.anime_200_method_response.id
}

output "aws_api_gateway_integration_response_id" {
  value       = aws_api_gateway_integration_response.anime_200_integration_response.id
}