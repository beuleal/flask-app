variable "ecr_repository_name" {
  default = "api"
  description = "ECR Repository name for Docker Image"
}

# Creates the ECr Repository for API Docker Image
resource "aws_ecr_repository" "api" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  # Collect vulnerability on scan
  image_scanning_configuration {
    scan_on_push = true
  }
}