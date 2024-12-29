user1 = User.create!(name: 'Jose da Silva', identification: 73_787_269_231,
                     email: 'usuario@email.com.br', password: '12345678', role: :client,
                     phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'SP',
                     zip_code: '22755-170')

user3 = User.create!(name: 'João Andrade', identification: 55_149_912_026,
                     email: 'admin@locaweb.com.br', password: '12345678', role: :administrator,
                     phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'SP',
                     zip_code: '22755-170')

user4 = User.create!(name: 'Adriana dos Santos', identification: 67_854_428_000,
                     email: 'adriana@email.com.br', password: '12345678', role: :client,
                     phone_number: '(11) 9 8888-7777', city: 'Rio Branco', state: 'SP',
                     zip_code: '22755-170')

category1 = CallCategory.create!(description: 'Financeiro')
category2 = CallCategory.create!(description: 'Suporte Técnico')
CallCategory.create!(description: 'Sugestões')
CallCategory.create!(description: 'Reclamações')

product1 = Product.create!(order_code: '4HXUDOZCDV', salesman: 'Jose', user_id: user1.id,
                           product_plan_name: 'Initial 100', product_plan_periodicity: 'Trimestral',
                           price: 100, discount: 20, payment_mode: 'Cartão de Crédito',
                           purchase_date: '2023-01-30', status: :active, cancel_reason: nil,
                           installation: :installed)

product2 = Product.create!(order_code: 'QDYGNXWDRL', salesman: 'Jose', user_id: user1.id,
                           product_plan_name: 'Plano Cloud', product_plan_periodicity: 'Anual',
                           price: 200, discount: 10, payment_mode: 'Cartão de Crédito',
                           purchase_date: '2023-01-30', status: :active, cancel_reason: nil,
                           installation: :installed)

Product.create!(order_code: 'ABC123', salesman: 'Jose', user_id: user1.id,
                product_plan_name: 'Plano Email', product_plan_periodicity: 'Anual',
                price: 200, discount: 10, payment_mode: 'Cartão de Crédito',
                purchase_date: '2023-02-05', status: :active, cancel_reason: nil,
                installation: :installed)

Product.create!(order_code: 'ABC654', salesman: 'Jose', user_id: user1.id,
                product_plan_name: 'Plano Email', product_plan_periodicity: 'Anual',
                price: 200, discount: 10, payment_mode: 'Cartão de Crédito',
                purchase_date: '2023-02-05', status: :canceled, cancel_reason: nil,
                installation: :uninstalled)

Product.create!(order_code: 'ABC987', salesman: 'Jose', user_id: user1.id,
                product_plan_name: 'Plano VPS', product_plan_periodicity: 'Anual',
                price: 200, discount: 10, payment_mode: 'Cartão de Crédito',
                purchase_date: '2023-02-10', status: :canceled, cancel_reason: nil,
                installation: :uninstalled)

product3 = Product.create!(order_code: 'ABC789', salesman: 'Jose', user_id: user4.id,
                           product_plan_name: 'Plano Email Marketing', product_plan_periodicity: 'Trimestral',
                           price: 300, discount: 30, payment_mode: 'Cartão de Crédito',
                           purchase_date: '2023-01-30', status: :active, cancel_reason: nil,
                           installation: :installed)

product4 = Product.create!(order_code: 'ABC321', salesman: 'Jose', user_id: user4.id,
                           product_plan_name: 'Plano Hospedagem II', product_plan_periodicity: 'Semestral',
                           price: 400, discount: 40, payment_mode: 'Cartão de Crédito',
                           purchase_date: '2023-01-30', status: :active, cancel_reason: nil,
                           installation: :installed)

call = Call.create!(call_code: 'XYZ123',
                    subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user_id: user1.id,
                    product_id: product1.id,
                    call_category_id: category1.id)

Call.create!(call_code: 'XYZ789',
             subject: 'Tamanho de armazenamento insuficiente',
             description: 'Por favor, aumentar o tamanho de armazenamento',
             status: :open,
             user_id: user1.id,
             product_id: product2.id,
             call_category_id: category2.id)

Call.create!(call_code: 'XYZ321',
             subject: 'Não consigo enviar e-mails',
             description: 'Estou tentando enviar emails mas não consigo',
             status: :open,
             user_id: user4.id,
             product_id: product3.id,
             call_category_id: category1.id)

Call.create!(call_code: 'XYZ456',
             subject: 'Não consigo acessar o painel de controle',
             description: 'Preciso utilizar o painel de controle para configurar o host',
             status: :open,
             user_id: user4.id,
             product_id: product4.id,
             call_category_id: category2.id)

CallMessage.create!(message: 'Mensagem 1', call_id: call.id, user_id: user1.id)
CallMessage.create!(message: 'Resposta 1', call_id: call.id, user_id: user3.id)
CallMessage.create!(message: 'Mensagem 2', call_id: call.id, user_id: user1.id)
CallMessage.create!(message: 'Resposta 2', call_id: call.id, user_id: user3.id)

CreditCard.create!(token: 'a96932kh324kh324h3g',
                   card_number: '4267',
                   owner_name: 'Banco Inter',
                   credit_card_flag: 'Visa',
                   user_id: user1.id)

CreditCard.create!(token: 'weereg34jhg34234kgk',
                   card_number: '2149',
                   owner_name: 'Banco Nubank',
                   credit_card_flag: 'Mastercard',
                   user_id: user1.id)

CreditCard.create!(token: 'jgj45g34hjg5jh35j43',
                   card_number: '8411',
                   owner_name: 'Cartão Itaú Personalite',
                   credit_card_flag: 'Mastercard',
                   user_id: user1.id)
