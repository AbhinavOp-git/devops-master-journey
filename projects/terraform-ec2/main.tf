# main.tf

resource "aws_instance" "devops_server" {
  ami           = "ami-02bb7d8191b50f4bb" # Latest Amazon Linux 2 AMI in Mumbai
  instance_type = var.instance_type
  key_name      = "devops-key"  # Your Key Pair Name in AWS Console

  tags = {
    Name = var.instance_name
  }
}
