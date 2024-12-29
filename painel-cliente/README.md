# Sobre o projeto

Esse projeto possui características similares ao contexto da venda de produtos para clientes da Locaweb. É composto por 4 diferentes aplicações: Sistema de Vendas, Gerenciador de Produtos, Gateway de Pagamentos e Painel de Clientes, que em conjunto compõem uma plataforma de vendas de serviços como hospedagem, serviços de e-mail, domínios etc. Essa aplicação específica é o Painel de Clientes, que possui suas próprias funcionalidades e regras de negócio. Além de suas próprias telas para cadastro e administração de dados, a aplicação expõe e consome dados das demais via APIs REST através do formato JSON.

O Painel do Cliente é o sistema acessado pelos clientes Locaweb para consultar seus produtos adquiridos, fazer mudanças nesses produtos, cancelar contratações e, quando necessário, abrir solicitações de atendimento ao suporte. Possui histórico da conta, com aquisição/cancelamento de produtos, solicitações de suporte etc. A aplicação também recebe dados de um pedido, via API, da aplicação de Vendas. A aplicação foi desenvolvida em Ruby on Rails, utilizando o framework LocaStyle (Design System Locaweb) para o front-end.

---
# Recursos e tecnologias utilizadas

  - Ruby 3.2.0
  - Rails 7.0.4.2
  - SQLite 3.40.0
  - Puma 5.0
  - Traduções com rails-i18n
  - Dotenv-rails
  - Faraday
  - Sistema de Login com Devise
  - Validação cpf/cnpj
  - LocaStyle (Design System Locaweb)
  - RSpect-rails
  - Capybara
  - Rubocop
  - Simplecov

---
# Layout

<img src="intro.gif" alt="Painel do Cliente" />

---
# Instalação e implantação do sistema

  1. Clone o repositório
  ```bash
  git clone git@git-qsd.campuscode.com.br:qsd8/painel-cliente.git
  ```
  2. Instale as dependências e crie o banco de dados
  ```bash
  bundle install
  bin/setup
  yarn install
  yarn build
  ```
  3.  Execute as migrações
  ```bash
  rails db:migrate
  ```
  4. Execute os seeds para popular o banco de dados
  ```bash
  rails db:seed
  ```
  5. Configure as variáveis de ambiente
  ```bash
  Configure as variáveis de ambiente no arquivo .env.development
  ```
  6. Inicie o servidor
  ```bash
  bin/dev
  ```
  7. Acesse o sistema
  ```bash
  http://localhost:3000
  ```
---
# Usuários padrão do sistema

Utilize os seguintes usuários para testar o sistema:
  - Usuário comum
    - email: usuario@email.com.br
    - senha: 12345678
  - Usuário administrador
    - email: admin@locaweb.com.br
    - senha: 12345678

OBS: Se o usuário for registrado a partir da App de Vendas, a senha inicial será seu CPF ou CNPJ.

---

# API

### Buscar cliente por CPF/CNPJ
  - GET http://localhost:3000/api/v1/clients/{identification}
    - Parâmetro: identification (CPF ou CNPJ)
      - Tipo: integer
    - Retorno: status 200 (ok) ou 404 (não encontrado)

### Cadastrar cliente
  - POST http://localhost:3000/api/v1/clients
    - Campos obrigatórios: name, email, identification
    - Identificação: CPF ou CNPJ
    - Retorno: status 200 (cadastrado) ou 400 (erro nas validações)
    - Payload:
```bash
  {
      "email": "usuario@email.com.br",
      "password": "12345678",
      "identification": 62207242080,
      "name": "Elvis Presley",
      "corporate_name": "",
      "address": "Av. Paulista 2500",
      "zip_code": "12345-900",
      "city": "São Paulo",
      "state": "SP",
      "phone_number": "(11) 9 9888-7777",
      "birthdate": "20/03/1990"
  }
```

### Confirmar pagamento de um pedido
  - POST http://localhost:3000/api/v1/order/paid
  - Retorno: status 201 (confirmado) ou 412 (acesso recusado)
  - Payload:
```bash
  { 
    "charge": 
      {
        "approve_transaction_number": "123456789",
        "disapproved_code": "",
        "disapproved_reason": "",
        "client_doc": "73787269231",  
        "order_code": "YI12C8UAJB"
      }
  }
```

### Confirmar desinstalação de um produto
  - POST http://localhost:3000/api/v1/product/{order_code}/uninstalled
    - Retorno: status 204 (atualizado com sucesso) ou 404 (produto não encontrado)
  
---
# Testes de sistema
A aplicação possui testes de sistema utilizando o framework Capybara. Para executá-los, execute o comando abaixo:
```bash
rspec -f d
```
Para testes específicos, utilize o comando abaixo, passando o caminho do arquivo de teste e a linha do teste:
```bash
rspec spec/{path}/{test_file_spec.rb:42}
```
Para informações sobre cobertura de testes de código, execute o comando abaixo:
```bash
COVERAGE=true rspec
```
