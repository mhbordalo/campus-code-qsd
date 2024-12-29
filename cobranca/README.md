# Sobre o projeto

Sistema criado para realizar as cobranças de novos pedidos usando cartão de crédito.
Administradores autenticados com e-mails do domínio @locaweb.com.br devem ser
capazes de cadastrar bandeiras de cartão de crédito e ver todas as cobranças pendentes.
Deverá ser capaz de aprovar as cobranças e gerar um código para aprovação.

O sistema deve disponibilizar também uma API que permita o cadastro de novos
cartões de crédito de clientes e a emissão de novas cobranças, que podem ser aprovadas
ou reprovadas. Também é responsabilidade deste sistema permitir a criação de promoções
de desconto.

As promoções definem taxas de descontos válidas para determinados
produtos durante um determinado período. A partir de cada promoção são gerados
cupons que poderão ser utilizados respeitando os limites e condições da promoção.

Os cupons podem ser inseridos no momento do pagamento de um pedido por um cliente e,
caso seja válido para o pedido, o desconto configurado na promoção deve ser aplicado.

---
# Dependências

  - Ruby 3.2.0
  - Rails 7.0.4.2
  - SQLite 3.40.0
  - Puma 5.0
  - yarn

## Principais libs

  - RSpec-rails
  - Capybara
  - Rubocop
  - LocaStyle (Design System Locaweb)

---

# Iniciando o projeto

  1. Clone o repositório
  ```bash
  git clone git@git-qsd.campuscode.com.br:qsd8/cobranca.git
  ```
  2. Instale as dependências
  ```bash
  bundle install
  yarn install
  bin/setup
  yarn build
  ```
  3.  Inicie o banco de dados
  ```bash
  rails db:migrate
  rails db:seed
  ```

  4. Inicie a aplicação
  ```bash
  bin/dev
  ```
  5. O sistema ficará disponível em http://localhost:3000

# Iniciando o projeto - Docker

  1. Após iniciar o projeto com os passos acima.
 
  2. Execute o seguinte comando para criar a imagem
  ```bash
  sudo docker build -t cobranca:v1 .
  ```

  3. Execute o seguinte comando para subir o container em segundo plano.
  ```bash
  sudo docker run -p 3000:3000 -d --name cobranca cobranca:v1
  ```
  4. Acesse o navegador com o seguinte endereço
  ```bash
  http://localhost:3000/
  ```
  5. Rode o comando abaixo para para o container
  ```bash
  sudo docker stop cobranca
  ```

---
# Usuários padrão do sistema

Os seguintes usuários estão disponíveis após executar o db::seed
  - Usuário padrão
    - email: usuario@locaweb.com.br
    - senha: 12345678
  - Usuário administrador
    - email: admin@locaweb.com.br
    - senha: 12345678

---

# Executar Testes Automáticos

A aplicação possui testes automáticos com Rspec. Execute o seguinte comando para rodá-los:
```bash
rspec
```

Para informações sobre cobertura de testes de código, execute o comando abaixo:
```bash
COVERAGE=true rspec
```
---
# API

O app fornece uma API para cartão de crédito, cobranças, consulta e utilização de cupons.

- Root end-point: http://localhost:3000/api/v1
- Versão: v1
- HEADERS:
- - Content-Type: application/json
- Autenticação: Não implementada
---

## Cartão de Crédito

### Cadastrar um cartão de crédito

- End-point: [POST] http://localhost:3000/api/v1/credit_cards
- Payload:
- Content-Type: application/json

- Descrição dos dados:
  - card_number:          Número do cartão.
  - validate_month:       Mês de validade do cartão.
  - validate_year:        Ano de validade do cartão.
  - cvv:                  Código de segurança do cartão.
  - owner_name:           Nome do proprietário que está impresso no cartão.
  - owner_doc:            Número do CPF do proprietário do cartão.
  - credit_card_flag_id:  Bandeira do cartão. [Considerando o seed]
    - 1- Bandeira Visa.
    - 2- Bandeira American-Express.
    - 3- Bandeira Mastercard.

Exemplo:
  - Enviando os dados JSon abaixo:
````js
{ "credit_card": {
    "card_number": "1234567890123456",
    "validate_month": "12",
    "validate_year": "30",
    "cvv": "123",
    "owner_name": "José da Silva",
    "owner_doc": "71880824485",
    "credit_card_flag_id": "1" }
}
````

- Obteremos a seguinte resposta:
- Código HTTP: 201 - created
- Descrição dos dados:
  - token: referência ao cartão de crédito cadastrado.
  - alias: final do cartão para identificação
  - flag_id: id da bandeira do cartão.
  - flag_name: bandeira do cartão.
````js
{
    "token": "5ERMZOP9DJSQXD9AFJTC",
    "owner_name": "José da Silva",
    "alias": "3456",
    "flag_id": 1,
    "flag_name": "VISA"
}
````

- Exemplo de retorno com falha:
- Código HTTP: 412
````js
{
    "errors": [
        "Mensagem de erro de acordo com o campo."
    ]
}
````
---
## Cobrança

### Cadastrar uma nova cobrança

- End-point: [POST] http://localhost:3000/api/v1/charges
- Payload:

- Descrição dos dados:
  - charge:            Cobrança
  - creditcard_token:  Token recebido ao criar o cartão [Precisa ser válido].
  - client_cpf:        CPF do cliente que está fazendo a compra.
  - order:             Id da ordem de serviço que está gerando a cobrança.
  - final_value:       Valor que deve ser cobrado do cliente.

Exemplo:
  - Enviando os dados JSon abaixo:
````js
{ "charge": {
    "creditcard_token":"5ERMZOP9DJSQXD9AFJTC",
    "client_cpf": "71880824485",
    "order": "1",
    "final_value": "150.00" }
}
````

- Obteremos a seguinte resposta:
- Código HTTP: 201 - created
- Descrição dos dados:
  - id: id da cobrança realizada.
````js
{
  "id": "1"
}
````

- Exemplo de retorno com falha:
- Código HTTP: 412
````js
{
    "errors": [
        "Mensagem de erro de acordo com o campo."
    ]
}
````

### Consultar uma cobrança

- End-point: [GET] http://localhost:3000/api/v1/charges/id

- Exemplo de retorno com sucesso:
- Código HTTP: 200 - OK
- Descrição dos dados:
  - id: id da cobrança realizada.
  - charge_status: status da cobrança [Aprovado, pendente ou reprovado]
  - approve_transaction_number: número da aprovação
  - created_at: data e hora da criação da cobrança
  - updated_at: data e hora da alteração [Aprovado, pendente ou reprovado]
  - client_cpf: CPF do cliente
  - order: ordem de serviço que gerou a cobrança
  - final_value: valor final cobrado
  - reasons_id: id do motivo da reprovação
  - creditcard_token: token do cartão utilizado no pagamento
````js
{
  "id": 1,
  "charge_status": "aproved",
  "approve_transaction_number": "2d931510-d99f-494a-8c67-87feb05e1594",
  "created_at": "2023-03-08T20:08:40.853Z",
  "updated_at": "2023-03-08T20:08:40.853Z",
  "client_cpf": "798.456.123-00",
  "order": 1002,
  "final_value": "5500.0",
  "reasons_id": 0,
  "creditcard_token": "5ERMZOP9DJSQXD9AFJTC"
}
````

- Exemplo de retorno com falha:
- Código HTTP: 400
````js
{
  "error": "Cobrança não encontrada."
}
````
## Promoções

### Cadastrar uma nova promoção

- Para cadastrar uma nova promoção o usuário precisará conectar-se ao sistema, clicar no
botão do menu lateral - Cadastrar Promoção.
- Precisará preencher corretamente os campos conforme descrição abaixo.

- Descrição dos dados:
  - Nome: Nome da promoção
  - Código: Código para a promoção
  - Data inicial: Data de início da promoção
  - Data final: Data do fim da promoção
  - Desconto: Percentual de desconto do cupom.
  - Valor máximo de desconto: Valor máximo do desconto em reais.
  - Quantidade de cupons: Quantidade de cupons que será gerado após aprovar a promoção.
  - Produtos: Produtos disponíves - API de Produtos - [Grupo de Produtos]

### Aprovar uma nova promoção

- Para aprovar uma promoção, o usuário que irá aprovar precisa ser diferente do usuário que criou a promoção.
- Após ser aprovada, a promoção irá gerar automaticamente os cupons da promoção e apresentá-los na tela.

### API de consulta de Cupom

- A consulta de cupons só será realizada se a promoção estiver aprovada, já iniciada e o cupom ainda não tiver sido utilizado.

- End-point: [GET] http://localhost:3000/api/v1/coupons/validate

- Necessário enviar os dados para consultar o cupom.
- Descrição dos dados:
  - coupon_code: código do cupom
  - product_plan_name: grupo de Produtos
  - price: preço do serviço

Exemplo:
  - Enviando os parâmetros abaixo por query ou formulário:
````js
{
    "coupon_code": "CAMPUSCODE-XLIR9",
    "product_plan_name": "SITE",
    "price": "1500.0"
}
````
- Obteremos a seguinte resposta:
- Código HTTP: 200 - OK
- Descrição dos dados:
  - coupon_code: código do cupom
  - discount: valor do desconto
  - price: preço total da compra
  - final_price: valor final após desconto

````js
{
    "code":"CAMPUSCODE-XLIR9",
    "price":"1500.0",
    "discount":"75.0",
    "final_price":"1425.0"
}
````

- Exemplo de retorno com falha:
- Código HTTP: 414 - Bad request
````js
{
    "error": "Dados não informados ou incompletos"
}
````

### API para utilização do Cupom

- A utilização do cupons só será realizada se o cupom for válido.

- End-point: [POST] http://localhost:3000/api/v1/coupons

- Necessário enviar os dados para consultar o cupom.
- Descrição dos dados:
  - coupon_code: código do cupom
  - product_plan_name: grupo de Produtos
  - price: preço do serviço
  - order_code: ordem de serviço em que o cupom está sendo utilizado

Exemplo:
  - Enviando os parâmetros abaixo por query ou formulário:
````js
{
    "coupon_code": "CAMPUSCODE-XLIR9",
    "product_plan_name": "SITE",
    "price": "1500.0",
    "order_code": "1"
}
````
- Obteremos a seguinte resposta:
- Código HTTP: 200 - OK
- Descrição dos dados:
  - coupon_code: código do cupom
  - discount: valor do desconto
  - price: preço total da compra
  - final_price: valor final após desconto

````js
{
    "code":"CAMPUSCODE-XLIR9",
    "price":"1500.0",
    "discount":"75.0",
    "final_price":"1425.0"
}
````

- Exemplo de retorno com falha:
- Código HTTP: 404 - Not found
````js
{
    "error":"Cupom inexistente ou inválido"
}
````