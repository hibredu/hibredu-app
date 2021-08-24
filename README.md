# Hibredu App

Interface de programação de aplicativo para o backend da aplicação Hibredu

## Tecnologias 

- NodeJS
- TypeScript
- Docker
- MySQL

## Get Started

Para rodar o projeto basta rodar estes comandos:

``` shell
# Acessa a pasta do projeto
cd app

# Executa em modo desenvolvedor
npm run dev
```

Para rodar com docker:
``` shell
sh ./start.sh
```

## Estrutura de Pastas
``` shell
└ app                           → Aplicação
    └ __tests__                 → Arquivos de testes(unidade e integração)
    └ src                       → Estrutura dos arquivos da aplicação
        └ app                   → Regras de negócio
        └ infrastructure        → Tudo relacionado a infraestrutura do servidor
        └ interface             → Arquivos que fazem comunicação com usuário ou outras aplicações (Controllers, Rotas)
└ docker                        → Arquivos e pastas relacionadas ao Docker
    └ sql                       → Pastas com arquivos dump.sql utilizados para popular o banco de dados criado pelo docker
└ docs                          → Documentação no Postman
 ```