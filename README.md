# CI/CD simples com aplicação SpringBoot com Maven + Jenkins + Terraform + AWS
1 - Primeiro precisamos instalar o Terraform:

```
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip terraform_0.11.14_linux_amd64.zip /usr/bin/
```
2 - Após isso, você precisa criar uma Access Key ID e Secret Key ID para seu usuário na Amazon, você pode seguir o procedimento que há no vídeo do link abaixo:

https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/

3 - Siga o procedimento abaixo:

```
git clone https://github.com/frovai/poc-teste.git
```
Crie uma pasta "keys" dentro do caminho "terraform-files/" e crie uma chave ssh.

```
cd terraform-files
mkdir keys
ssh-keygen
```
OBS: Ao rodar o ssh-keygen , coloque o caminho de saída da chave para "./keys/id-chave

Mova o arquivo que está na raíz "terraform.tfvars-bkp" para a pasta "terraform-files" com o nome "terraform.tfvars" e edite o arquivo conforme as informações solicitadas nele.
```
mv terraform-tfvars-bkp terraform-files/terraform.tfvars
```
Edite conteúdo
```
# vim terraform-files/terraform.tfvars


  aws_access_key = "SUA-ACCESS-KEY-AQUI"
  aws_secret_key = "SUA-SECRET-KEY-AQUI"
  aws_key_name = "NOME-DA-SUA-CHAVE"
  aws_key_path = "CAMINHO-DA-SUA-CHAVE-AQUI"
```

4 - Entre no caminho terraform-files/, inicialize o Terraform e aplique as configurações.

```
cd terraform-files
terraform init
terraform plan
terraform apply
```

5 - Configure a instalação do Jenkins:

6 - Instale plugin para Docker Slave no Jenkins:

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/manage-jenkins.png)

7 - Configure variável global no Jenkins e adicione uma chave SSH no Jenkins:

8 - Configure Job no Jenkins

9 - Rode o job e valide o deploy

