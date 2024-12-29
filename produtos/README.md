# PRODUTOS

Este projeto é um sistema de Gestão de Produtos que permite ao time de Marketing de Produtos
cadastrar e configurar novos produtos, seus preços e condições de vendas.
Todos os produtos são serviços online como Plataformas de e-mail, Hospedagem de sites, registro de Domínios, etc.

O projeto é desenvolvido em Ruby versão 3.2.0

## Instalação

1. Instalar as dependências e bibliotecas:

```
- Executar a sequência:
  - bundle install
  - bin/setup
  - yarn install
  - yarn build
```

2. Montar o banco de dados e popular com dados para testes:

```
rails db:migrate db:seed
```

3. Rodar o servidor:

```
bin/dev
```

Após estes passos já pode acessar via web na url `http://localhost:3000`

Para utilizar o sistema é necessário autenticação utilizando e-mail com Domínio locaweb.com.br

Pode utilizar os dados abaixo para testes:

 |Usuário| Senha|
 |--|---|
 |admin@locaweb.com.br|123456|
 |user@locaweb.com.br|123456|
 |teste@locaweb.com.br|123456|


## Testes
 
O projeto utiliza `rspec` nos testes do modelo e de sistema: 
```
rspec
```

- Para rodar um teste especifico pode utilizar:

```
rspec ./spec/system/plans/user_edit_plan_spec.rb:4
```
E utiliza `rubocop` nos teste de boas práticas:
```
rubocop
```
<br>

## APIs - Endpoints
<br>
<details>
  <summary>
    <b>API Grupo de Produtos</b>
  </summary>
  <br>

* Descrição: Fornecer os dados dos Grupos de Produtos disponíveis.
* Verbo: GET
* URI: /api/v1/product_groups/
* Payload: -
* Exemplo:

```
GET http://localhost:3000/api/v1/product_groups/

JSON return:
[
   {
      "id":1,
      "name":"Hospedagem de Sites",
      "description":"Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício",
      "code":"HOST",
      "status":"active"
   },
   {
      "id":2,
      "name":"E-mail Locaweb",
      "description":"Tenha um e-mail profissional e passe mais credibilidade",
      "code":"EMAIL",
      "status":"active"
   },
   {
      "id":3,
      "name":"Criador de Sites",
      "description":"Crie um site incrível com e-mails e domínio grátis!",
      "code":"SITE",
      "status":"active"
   }
]
```
</details>

<br>
<details>
  <summary>
    <b>API Planos</b>
  </summary>
  <br>

* Descrição: Fornece a lista de planos a partir de um grupo de produto.
* Verbo: GET
* URI: api/v1/product_groups/:product_group_id/plans/
* Payload: -
* Exemplo:

```
GET http://localhost:3000/api/v1/product_groups/1/plans/

JSON return:

[
   {
      "id":1,
      "name":"Hospedagem GO",
      "description":"1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis",
      "product_group_id":1,
      "status":"active",
      "details":"1 usuário FTP, Armazenamento e Transferencia ilimitada"
   },
   {
      "id":2,
      "name":"Hospedagem I",
      "description":"Sites ilimitados, 25 Contas de e-mails(10GB cada), 1 ano de domínio grátis",
      "product_group_id":1,
      "status":"active",
      "details":"1 usuário FTP, Armazenamento e Transferencia ilimitada"
   },
   {
      "id":3,
      "name":"Hospedagem II",
      "description":"Sites ilimitados, 50 Contas de e-mails(10GB cada), 1 ano de domínio grátis",
      "product_group_id":1,
      "status":"active",
      "details":"5 usuários FTP, Armazenamento e Transferencia ilimitada"
   }
]
```
</details>

<br>
<details>
  <summary>
    <b>API Periodicidades</b>
  </summary>
  <br>

* Descrição: Fornece os dados das Periodicidades cadastradas.
* Verbo: GET
* URI: /api/v1/periodicities/
* Payload: -
* Exemplo:

```
GET http://localhost:3000/api/v1/periodicities/

JSON return:
[
  {
    "id": 1,
    "name": "Mensal",
    "deadline": 1
  },
  {
    "id": 2,
    "name": "Trimestral",
    "deadline": 3
  },
  {
    "id": 3,
    "name": "Anual",
    "deadline": 12
  }
]
```
</details>

<br>
<details>
  <summary>
    <b>API Preços de plano por periodicidades</b>
  </summary>
  <br>

* Descrição: Fornece preços de um plano alinhados com as periodicidades disponíveis.
* Verbo: GET
* URI: /api/v1/plans/:plan_id/prices
* Payload: -
* Exemplo:

```
GET http://localhost:3000/api/v1/plans/1/prices

JSON return:
[
	{
		"id": 1,
		"price": "38.97",
		"plan": {
			"id": 1,
			"name": "Hospedagem GO",
			"description": "1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis",
			"product_group_id": 1,
			"details": "1 usuário FTP, Armazenamento e Transferencia ilimitada"
		},
		"periodicity": {
			"id": 2,
			"name": "Trimestral",
			"deadline": 3
		},
		"product_group": {
			"id": 1,
			"name": "Hospedagem de Sites",
			"description": "Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício",
			"code": "HOST"
		}
	},
	{
		"id": 2,
		"price": "119.88",
		"plan": {
			"id": 1,
			"name": "Hospedagem GO",
			"description": "1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis",
			"product_group_id": 1,
			"details": "1 usuário FTP, Armazenamento e Transferencia ilimitada"
		},
		"periodicity": {
			"id": 3,
			"name": "Anual",
			"deadline": 12
		},
		"product_group": {
			"id": 1,
			"name": "Hospedagem de Sites",
			"description": "Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício",
			"code": "HOST"
		}
	}
]
```
</details>

<br>
<details>
  <summary>
    <b>API Instalação de Produto</b>
  </summary>
  <br>

* Descrição: Cadastra o pedido informado e Fornece o servidor onde foi instalado o produto informado no pedido.
* Verbo: POST
* URI: /api/v1/products/install
* Payload:
   {
    order_code: string,
    customer_document: string,
    plan_name: string
   }
* Exemplo 1: (cadastrado com sucesso) 

```
POST http://localhost:3000/api/v1/products/install
      {
        order_code: '123415',
        customer_document: '620.713.365-31',
        plan_name: 'Hospedagem Básica'
      }

JSON return:
	{
		"code": "LINUX-HOST-Q1W2E3R4"
	}
```
</details>

<br>
<details>
  <summary>
    <b>API Desinstalação de Produto</b>
  </summary>
  <br>

* Descrição: Desinstala o produto do pedido informado.
* Verbo: POST
* URI: /api/v1/products/uninstall
* Payload:
   {
    order_code: string,
    customer_document: string,
    plan_name: string
   }
* Exemplo:

```
POST http://localhost:3000/api/v1/products/uninstall
      {
        order_code: '123415',
        customer_document: '620.713.365-31',
        plan_name: 'Hospedagem Básica'
      }

JSON return:
	{
		"status": "inactive"
	}
```
</details>

<br>

## Métodos
<br>
As requisições para as APIs devem seguir os padrões:

| Método | Descrição |
|---|---|
| `GET` | Retorna informações de um ou mais registros. |
| `POST` | Utilizado para criar um novo registro. |

<br>

## Respostas

| Código | Descrição |
|---|---|
| `200` | Requisição executada com sucesso (success).|
| `404` | Registro pesquisado não encontrado (Not found).|
| `500` | Falha de conexão (Internal Server Error).|