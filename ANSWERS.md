# Desafio DevOps
[![CircleCI](https://circleci.com/gh/cadugoncalves96/desafio-devops.svg?style=svg)](https://circleci.com/gh/cadugoncalves96/desafio-devops) [![made-with-python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)](https://www.python.org/) 


Mais informações sobre o desafio, acesse o [Readme](./README.md) deste repositório.

## Sumário

  - [Requisitos](#requisitos)
  - [Testando a aplicação](#testando-a-aplicação)
  - [Desafio](#desafio)
  - [Stack local](#stack-local)
  - [Arquitetura](#arquitetura)
  - [Configuração](#configuração)
  - [Executando o terraform](#executando-o-terraform)
  - [Deploy](#deploy)
  - [Autor](#autor)

## Requisitos

Para reproduzir o ambiente na sua cloud, você precisa ter os requisitos abaixo:

- Uma conta na AWS - com Access Key Id, Secret Access Key e Region para configurar o Terraform.
- S3 Bucket - Para salvar os states do terraform.
- Um certificado válido de um domínio no ACM - Para validar a rota do Route 53, e para permitir conexões HTTPS no LoadBalancer.
- Um domínio no Route 53 - para criarmos um ALIAS e apontar para a rota do LoadBalancer.
- Uma keypair válida para acessar as instâncias.


### Pré-requisitos

Utilizamos as seguintes técnologias para criar e configurar todo o processo.

- [Terraform](https://www.terraform.io/) versão v0.12.24, ou maior.
- [CircleCI](https://circleci.com/) versão 2.1.
- [Python](https://www.python.org/) versão 3.6 ou maior.
- [Pipenv](https://github.com/pypa/pipenv) versão 2018.11.26 ou maior.

Para continuar, certifique-se de que possui todas as dependências citadas acima.

## Testando a aplicação

Para testar a aplicação, utilize o comando abaixo na raíz do projeto:

```
cd base-test-api/ && BASE_API_ENV=test pipenv run pytest
```

## Desafio

A seguir, todos os pontos solicitados no desafio.

### Stack local

Para rodar localmente, utilizamos o Dockerfile na raíz do projeto. Rode o comando abaixo para buildar o container:

```
sudo docker build -t cadugoncalves96/ping-pong:latest .
```

Em seguida, inicie o container:
```
sudo docker run -itd -p 8080:8080 cadugoncalves96/ping-pong:latest   
```

Se acessar o link http://localhost:8080/api/ping verá que o container subiu e está rodando.

### Arquitetura

A arquitetura construída com Terraform, foi para se assemelhar com um ambiente produtivo, possuindo um arquivo de configuração dentro do projeto, podendo ter diversos arquivos para diversos ambientes. A seguir, um diagrama de como foi montada a arquitetura:

![alt text](/docs/img/img_001.png "Desenho da arquitetura.")

Resumidamente, foram construídos os seguintes recursos:

- 1 rota no route 53 - Para ser acessada pelo usuário. Esse ALIAS contém o domínio do Load Balancer.
- 1 Application Load Balancer - Para distribuir tráfego entre todas as intâncias. Ele recebe tráfego na porta 80, e 443, e direciona para o Target Group na porta 8080, da aplicação.
- 1 Target Group - Para receber o tráfego do Application Load Balancer. Recebe tráfego na porta 8080, e direciona para as instâncias.
- 1 Autoscalling group - Para escalonar as instâncias. Também são criadas regras de escalonamento de acordo com utilização de CPU. Se bater 50% de uso de CPU ele sobe mais uma instância. Se a utilização estiver abaixo de 50%, ele derruba uma instância, sendo o mínimo, o máximo e o desejável podendo ser configurados como quiser.
- 1 instância t3.micro - Mínimo de instâncias no Autoscalling Group, com o tipo T3.micro. São configuradas com user data assim que são iniciadas.

### Configuração

Para configurar a arquitetura, basta preencher o arquivo 'production.tfvars' dentro da pasta 'terraform/'. Abaixo, um exemplo de como pode ser utilizado.

```
# A região que irá utilizar
region = "us-east-1"

# O nome do App, pode ser alterado caso queira.
app = "ping-pong"

# Qual environment essa arquitetura pertence.
env = "production"

# Qual tag deve ser utilizar para baixar e rodar o docker dentro das intâncias.
app_tag = "latest"

# Uma lista de subnets públicas para o Load Balancer manter a alta disponibilidade. Mínimo de 2 subnets.
public_subnet_ids = ["subnet-0fadbefae3a1f7790", "subnet-0c6f284eb26b028e3"]

# Uma lista de subnets privadas para que sirvam de Targets para o Load Balancer. Colocar as instâncias na privada ajuda a garantir a segurança de acesso nas instâncias.
private_subnet_ids = ["subnet-00100572f75008349","subnet-04ac197510e6430fe"]

# O mínimo de instâncias aceitas no grupo de escalonamento.
minimum_scale = "1"

# O máximo de instâncias aceitas no grupo de escalnamento.
maximum_scale = "1"

# A quantidade ideal de intâncias aceitas no grupo de escalonamento. O grupo sempre tentará atingir essa média.
desired_scale = "1"

# Qual tipo de instância o grupo usará.
instance_type = "t3.micro"

# Uma keypair válida para permitir acesso às intâncias
instance_key_name = "chave-mestra"

# O ARN do certificado ACM. Ele é utilizado nas configurações do Load Balancer para permitir HTTPS.
lb_certificate = "arn:aws:acm:us-east-1:355903221802:certificate/3963b5d3-de23-40df-8c55-5b69fe99c563"

# O nome do domínio no Route 53. E.g. tembici.com
domain_name = "caduzerando.com"

# O nome do ALIAS que será dado à rota da api. E.g api.tembici.com
api_name = "api"

# O id de uma VPC válida.
vpc_id = "vpc-0850996ad30dc7a5d"

# O id da zona do domínio.
zone_id = "Z10388502AP1GZGZ4FSGF"
```

É possivel ter diversos arquivos de configuração. Abaixo, veremos como executar a arquitetura utilizando um deles. Lembre-se de NUNCA colocar credenciais ou senhas dentro dos arquivos de configuração.

### Executando o terraform

Antes de construir toda a infraestrutura, lembre-se de configurar o bucket correto no arquivo [main.tf](terraform/main.tf), para salvar seus states.

Para rodar o terraform, basta executar o comando abaixo, na raíz do projeto, passando o arquivo de configuração desejado. 
```
cd terraform/ && terraform init && terraform apply -var-file="production.tfvars"
```

O backend será iniciado, validando com o tfstate guardado no S3 bucket, cajo haja. E logo após, será executado o comando para criar toda a infraestrutura.

Caso queira validar antes, rode o comando abaixo:
```
cd terraform/ && terraform init && terraform plan -var-file="production.tfvars"
```

### Deploy

O deploy acontece com o CircleCi. Nele, foram configurados 3 jobs:
- Tests
- Build-docker
- Run-terraform

#### Job Tests

É o job que executa os testes da aplicação. Todos os testes contidos na aplicação serão executados e validados. Caso algum deles quebre, o job falhará.

#### Build-docker

É o job que builda uma nova imagem do docker. Esse job sempre criará duas imagens, uma 'latest', e outra com o Hash do commit, para manter o acompanhamento de versões.

Este job só é executado quando há um novo commit na master, apenas.

#### Run-terraform

É o job responsável por rodar os comandos Terraform e construir a infraestrutura em sí.

Este job só é executado quando há um novo commit na master, apenas.

## Autor

  - **Carlos 'Cadu' Gonçalves** - [cadugoncalves96/desafio-devops](https://github.com/cadugoncalves96/desafio-devops)