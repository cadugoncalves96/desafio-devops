# desafio devops.

O critério de avaliação desse teste é analizar as formas de pensar e organização do candidato, qualidade de código e simplicidade serão avaliados também. Sinta-se livre para desenvolver linhas de raciocino, comentar, etc... E em caso de dúvidas, não tenha vergonha de enviar um email.

## Forma de entrega:
	Fork o repositório e altere o arquivo ANSWERS.md com as respostas e observaçõesa que achar necessário para rodar o código e possiveis considerações adicionais. Faça os commits no seu repositório e no final nos envie um arquivo zipado para avaliarmos.


## Objetivos
	Dentro do repositório tem uma aplicação Flask bem simples, é uma API que responde `pong` à rota `/ping`.

	Para executar a aplicação é necessário python 3.6 e o pipenv, rode os seguintes comandos:
		pipenv install
		pipenv run python start.py runserver

	Para executar os testes da aplicação rode o comando:
		BASE_API_ENV=test pipenv run pytest

	Dito isso, você deverá Dockerizar e fazer o deploy da aplicação na AWS (será um adicional se utilizar GCP), criar uma forma que possamos subir essa aplicação localmente de forma simples, colocar esta aplicação em um fluxo de CI que realize teste neste código e o deploy da aplicação. Você provavelmente precisará de uma conta free-tier da AWS ou uma já existente, mas não se preocupe, não iremos olhar sua conta ou chamar a api já rodando, queremos que você crie uma forma que possamos recriar toda sua infraestrutura em nossa conta de forma simples. Mas por favor, leve em conta que seria um ambiente muito próximo à produção, portanto, escalabilidade, billing, segurança, monitoramento e logging tudo isso será levado em consideração na nossa análise. Sinta-se livre para usar as ferramentas que julgue necessário.


**Boa sorte!**
