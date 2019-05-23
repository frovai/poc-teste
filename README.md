# CI/CD simples com aplicação SpringBoot com Maven + Jenkins + Terraform + AWS
1 - Primeiro precisamos instalar o Terraform:

```
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip terraform_0.11.14_linux_amd64.zip -d /usr/bin/
```
2 - Após isso, você precisa criar uma **AWS Access Key** e **AWS Secret Key** para seu usuário na Amazon, você pode seguir o procedimento que há no vídeo do link abaixo:

https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/

3 - Siga o procedimento abaixo:

```
git clone https://github.com/frovai/poc-teste.git
```
Crie uma pasta **"keys"** dentro do caminho **"terraform-files/"** e crie uma chave ssh.

```
cd terraform-files
mkdir keys
ssh-keygen
```
OBS: Ao rodar o ssh-keygen , coloque o caminho de saída da chave para **"./keys/id-chave"**

Mova o arquivo que está na raíz **"terraform.tfvars-bkp"** para a pasta **"terraform-files"** com o nome **"terraform.tfvars"** e edite o arquivo conforme as informações solicitadas nele.
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

4 - Entre no caminho **terraform-files/**, inicialize o Terraform e aplique as configurações.

```
cd terraform-files
terraform init
terraform plan
terraform apply
```

5 - Configure a instalação do Jenkins:

Abra a página inicial do Jenkins com o IP púlbico que a AWS gerou para você.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Unlock-Jenkins.png)

Você terá que logar na instância do Jenkins com a chave ssh criada no começo desse tutorial e rodar o comando **"docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword"** para pegar a senha para desbloquear a instalação do Jenkins.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/InitialAdminPassword-Jenkins.png)

Prossiga instalando os plugins recomendados.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Install-suggested-plugins.png)

Crie um usuário conforme desejado.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Create-First-Admin-User.png)

Apenas confirme a tela a seguir.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Instance-Configuration.png)

Instalação finalizada.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Instalado-OK.png)

6 - Instale plugin para Docker Slave no Jenkins:

Na página inicial vá no canto esquerdo da tela em **"Manage Jenkins"**.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/manage-jenkins.png)

Na página seguinte, entre na opção **"Manage Plugins"**

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/manage-plugins.png)

Escolha ambos plugins conforme imagem abaixo:

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/plugins-docker.png)

Logo abaixo da tela confirme o Download e instalação dos plugins.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Download-install-plugins.png)

Volte na página inicial do Jenkins e vá novamente na opção **"Manage Jenkins"**. Após essa opção você poderá seguir na opção **"Configure System"**.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Configure-System.png)

Na opção aberta, procure **"Docker Slaves"**. Preencha esta opção conforme o print abaixo, deixando o **"Docker Host URI"** como **"tcp://127.0.0.1:2375"**. Configurando dessa forma, significa que sempre que o Jenkins chamar um Jobs através de um Docker agent, o mesmo irá executar no próprio Host do Jenkins na imagem de container selecionada na pipeline.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Docker-slave-configura.png)


7 - Configure variável global no Jenkins e adicione uma chave SSH no Jenkins:

Volte na página inicial do Jenkins e vá novamente na opção **"Manage Jenkins"**. Após essa opção você poderá seguir na opção **"Configure System"**.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Configure-System.png)

Configure a variável **SPRING_SERVER** conforme abaixo:

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Global-Spring-Server.png)

Volte para página inicial e seleciona a opção **"Credentials"**.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Credentials.png)

Nas telas seguintes, siga selecionando as opções conforme prints abaixo:

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Credentials-Jenkins.png)

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Credentials-System-Globalcredentials.png)

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Jenkins%3ECredentials%3ESystem%3EGlobalCredentials%3EAddCredentials.png)

Agora configure conforme abaixo, com um ID **"DEPLOY_KEY"** e na opção "Private Key" copie e cole o conteúdo da chave criada no começo desse tutorial neste campo.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/SSH-PrivateKey%3EDeploy-key.png)

Chave criada como variável no Jenkins.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Chave-SSH-criada-Jenkins.png)

8 - Configure Job no Jenkins

Crie um job do tipo pipeline com o nome desejado.

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Create-Pipeline.png)

Na tela seguinte tique a opção **"Build periodically"** com o valor **"H/5 * * * *"**

![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Build-Triggers-5em5min.png)

Logo mais abaixo na tela, configure conforme abaixo.
```
SCM : Git
Repository URL: https://github.com/frovai/poc-teste.git
Branch Specifier (blank for 'any') : * /master
Script Path : terraform-files/CI/Jenkinsfile
```
![alt text](https://github.com/frovai/poc-teste/blob/develop/images/Pipeline-pipeline-scm.png)

9 - Rode o job e valide o deploy

