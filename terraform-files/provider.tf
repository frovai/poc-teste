## Escolhe provider AWS e adiciona a regiao "us-east-1", nos campos "access_key" e "secret_key" voce deve colocar suas credenciais no local.

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
