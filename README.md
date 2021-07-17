# Hibredu App

Interface de programação de aplicativo para o backend da aplicação Hibredu

## Tecnologias 

- NodeJS
- MySQL

## Get Started

Para rodar o projeto basta rodar estes comandos:

``` shell
npm run start
```

Para rodar com docker:
``` shell
docker-compose up --build
```

## Estrutura de Pastas
``` shell
└ app                           → Aplicação
    └ src                       → Estrutura dos arquivos da aplicação
        └ app                   → Regras de negócio
        └ infrastructure        → Tudo relacionado a infraestrutura do servidor
        └ interface             → Arquivos que fazem comunicação com usuário ou outras aplicações (Controllers, Rotas)
└ docker                        → Arquivos e pastas relacionadas ao Docker
    └ sql                       → Pastas com arquivos dump.sql utilizados para popular o banco de dados criado pelo docker
 ```