provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name   = "my_keypair"
  public_key = file(var.key_path)
}