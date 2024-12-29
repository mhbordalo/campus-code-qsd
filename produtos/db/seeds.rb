# Users
User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '123456')
User.create!(name: 'user', email: 'user@locaweb.com.br', password: '123456')
User.create!(name: 'teste', email: 'teste@locaweb.com.br', password: '123456')
# Product Groups
group_a = ProductGroup.create!(name: 'Hospedagem de Sites',
                               description: 'Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício',
                               code: 'HOST')
group_b = ProductGroup.create!(name: 'E-mail Locaweb',
                               description: 'Tenha um e-mail profissional e passe mais credibilidade',
                               code: 'EMAIL')
group_c = ProductGroup.create!(name: 'Criador de Sites',
                               description: 'Crie um site incrível com e-mails e domínio grátis!',
                               code: 'SITE')
# Periodicities
periodicity_a = Periodicity.create!(name: 'Mensal', deadline: 1)
periodicity_b = Periodicity.create!(name: 'Trimestral', deadline: 3)
periodicity_c = Periodicity.create!(name: 'Anual', deadline: 12)
# Plans
plan_a = Plan.create!(name: 'Hospedagem GO', status: :active,
                      description: '1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                      product_group: group_a,
                      details: '1 usuário FTP, Armazenamento e Transferencia ilimitada')
plan_b = Plan.create!(name: 'Hospedagem I', status: :active,
                      description: 'Sites ilimitados, 25 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                      product_group: group_a,
                      details: '1 usuário FTP, Armazenamento e Transferencia ilimitada')
plan_c = Plan.create!(name: 'Hospedagem II', status: :active,
                      description: 'Sites ilimitados, 50 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                      product_group: group_a,
                      details: '5 usuários FTP, Armazenamento e Transferencia ilimitada')
plan_d = Plan.create!(name: 'Hospedagem VPS', status: :active,
                      description: 'Sites ilimitados, 100 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                      product_group: group_a,
                      details: '4GB de memória, 2vCPUs, 120GB SSD, Transferencia ilimitada')
plan_e = Plan.create!(name: 'Hospedagem Pro', status: :discontinued,
                      description: 'Sites e contas de e-mails ilimitados, domínio grátis',
                      product_group: group_a,
                      details: '8GB de memória, 4vCPUs, 240GB SSD, Backup e restore grátis')
plan_f = Plan.create!(name: 'Initial 25', status: :active,
                      description: '25 contas de e-mail',
                      product_group: group_b,
                      details: '15 GB de espaço por conta de e-mail, A partir de R$ 1,30 por conta de e-mail')
plan_g = Plan.create!(name: 'Initial 50', status: :active,
                      description: '50 contas de e-mail, Domínio grátis',
                      product_group: group_b,
                      details: '15 GB de espaço por conta de e-mail, A partir de R$ 0,94 por conta de e-mail')
plan_h = Plan.create!(name: 'Initial 100', status: :active,
                      description: '100 contas de e-mail, Domínio grátis',
                      product_group: group_b,
                      details: '15 GB de espaço por conta de e-mail, A partir de R$ 0,88 por conta de e-mail')
plan_i = Plan.create!(name: 'Básico', status: :active,
                      description: '02 contas de E-mail de 10 GB, Domínio grátis, SSL grátis',
                      product_group: group_c,
                      details: '01 site com páginas ilimitadas, Mais de 130 templates gratuitos')
plan_j = Plan.create!(name: 'Intermediário', status: :active,
                      description: '10 contas de E-mail de 10 GB, Domínio grátis, SSL grátis',
                      product_group: group_c,
                      details: '01 site com páginas ilimitadas, Mais de 130 templates gratuitos')
plan_k = Plan.create!(name: 'Avançado', status: :discontinued,
                      description: '10 contas de E-mail de 10 GB, Domínio grátis, SSL grátis',
                      product_group: group_c,
                      details: '01 site com páginas ilimitadas, Mais de 130 templates gratuitos')
# Prices
Price.create!(price: 38.97, plan: plan_a, periodicity: periodicity_b, status: :active)
Price.create!(price: 119.88, plan: plan_a, periodicity: periodicity_c, status: :active)
Price.create!(price: 59.97, plan: plan_b, periodicity: periodicity_b, status: :active)
Price.create!(price: 191.88, plan: plan_b, periodicity: periodicity_c, status: :active)
Price.create!(price: 80.97, plan: plan_c, periodicity: periodicity_b, status: :active)
Price.create!(price: 299.88, plan: plan_c, periodicity: periodicity_c, status: :active)
Price.create!(price: 49.99, plan: plan_d, periodicity: periodicity_a, status: :active)
Price.create!(price: 98.97, plan: plan_e, periodicity: periodicity_b, status: :active)
Price.create!(price: 371.88, plan: plan_e, periodicity: periodicity_c, status: :active)
Price.create!(price: 36.80, plan: plan_f, periodicity: periodicity_a, status: :active)
Price.create!(price: 106.50, plan: plan_f, periodicity: periodicity_b, status: :active)
Price.create!(price: 390.00, plan: plan_f, periodicity: periodicity_c, status: :active)
Price.create!(price: 46.80, plan: plan_g, periodicity: periodicity_a, status: :active)
Price.create!(price: 136.5, plan: plan_g, periodicity: periodicity_b, status: :active)
Price.create!(price: 510.00, plan: plan_g, periodicity: periodicity_c, status: :active)
Price.create!(price: 61.80, plan: plan_h, periodicity: periodicity_a, status: :active)
Price.create!(price: 181.50, plan: plan_h, periodicity: periodicity_b, status: :active)
Price.create!(price: 690.00, plan: plan_h, periodicity: periodicity_c, status: :active)
Price.create!(price: 20.70, plan: plan_i, periodicity: periodicity_b, status: :active)
Price.create!(price: 58.80, plan: plan_i, periodicity: periodicity_c, status: :active)
Price.create!(price: 47.70, plan: plan_j, periodicity: periodicity_b, status: :active)
Price.create!(price: 178.80, plan: plan_j, periodicity: periodicity_c, status: :active)
Price.create!(price: 77.70, plan: plan_k, periodicity: periodicity_b, status: :active)
Price.create!(price: 298.80, plan: plan_k, periodicity: periodicity_c, status: :active)
Price.update(status: :active)
# Servers
server_a = Server.create!(operational_system: :windows, os_version: '10.3.7',
                          number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                          product_group: group_a, type_of_storage: :ssd)
server_b = Server.create!(operational_system: :windows, os_version: '10.3.7',
                          number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                          product_group: group_a, type_of_storage: :hd)
server_c = Server.create!(operational_system: :linux, os_version: 'Debian 11.6',
                          number_of_cpus: 32, storage_capacity: 6144, amount_of_ram: 16, max_installations: 50,
                          product_group: group_a, type_of_storage: :ssd)
server_d = Server.create!(operational_system: :windows, os_version: 'Debian 11.6',
                          number_of_cpus: 32, storage_capacity: 6144, amount_of_ram: 16, max_installations: 50,
                          product_group: group_a, type_of_storage: :hd)
server_e = Server.create!(operational_system: :windows, os_version: '10.3.7',
                          number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 100,
                          product_group: group_b, type_of_storage: :ssd)
server_f = Server.create!(operational_system: :windows, os_version: '10.3.7',
                          number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 100,
                          product_group: group_b, type_of_storage: :hd)
server_g = Server.create!(operational_system: :linux, os_version: 'Debian 11.6',
                          number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 16, max_installations: 100,
                          product_group: group_b, type_of_storage: :ssd)
server_h = Server.create!(operational_system: :windows, os_version: 'Debian 11.6',
                          number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 16, max_installations: 100,
                          product_group: group_b, type_of_storage: :hd)
server_i = Server.create!(operational_system: :windows, os_version: '10.3.7',
                          number_of_cpus: 16, storage_capacity: 4096, amount_of_ram: 16, max_installations: 180,
                          product_group: group_c, type_of_storage: :ssd)
server_j = Server.create!(operational_system: :windows, os_version: '10.3.7',
                          number_of_cpus: 16, storage_capacity: 4096, amount_of_ram: 16, max_installations: 180,
                          product_group: group_c, type_of_storage: :hd)
server_k = Server.create!(operational_system: :linux, os_version: 'Debian 11.6',
                          number_of_cpus: 16, storage_capacity: 4096, amount_of_ram: 8, max_installations: 200,
                          product_group: group_c, type_of_storage: :ssd)
server_l = Server.create!(operational_system: :windows, os_version: 'Debian 11.6',
                          number_of_cpus: 16, storage_capacity: 4096, amount_of_ram: 8, max_installations: 200,
                          product_group: group_c, type_of_storage: :hd)
# Install_products
InstallProduct.create!(customer_document: '001.001.001-01', order_code: 'ABC123', server: server_a)
InstallProduct.create!(customer_document: '002.002.002-02', order_code: 'DEF456', server: server_b)
InstallProduct.create!(customer_document: '003.003.003-03', order_code: 'GHI789', server: server_c)
InstallProduct.create!(customer_document: '004.004.004-04', order_code: 'JKL123', server: server_d)
InstallProduct.create!(customer_document: '005.005.005-05', order_code: 'MNO456', server: server_e)
InstallProduct.create!(customer_document: '006.006.006-06', order_code: 'PQR789', server: server_f)
InstallProduct.create!(customer_document: '007.007.007-07', order_code: 'STU123', server: server_g)
InstallProduct.create!(customer_document: '008.008.008-08', order_code: 'WVX456', server: server_h)
InstallProduct.create!(customer_document: '009.009.009-09', order_code: 'YZA789', server: server_i)
InstallProduct.create!(customer_document: '010.010.010-10', order_code: 'BCD123', server: server_j)
InstallProduct.create!(customer_document: '011.011.011-11', order_code: 'EFG456', server: server_k)
InstallProduct.create!(customer_document: '012.012.012-12', order_code: 'HIJ789', server: server_l)
InstallProduct.create!(customer_document: '001.001.001-01', order_code: 'ABC111', server: server_a)
InstallProduct.create!(customer_document: '002.002.002-02', order_code: 'ABC222', server: server_a)
InstallProduct.create!(customer_document: '003.003.003-03', order_code: 'ABC333', server: server_a)
InstallProduct.create!(customer_document: '004.004.004-04', order_code: 'ABC444', server: server_a)
InstallProduct.create!(customer_document: '005.005.005-05', order_code: 'DEF444', server: server_b)
InstallProduct.create!(customer_document: '006.006.006-06', order_code: 'DEF555', server: server_b)
InstallProduct.create!(customer_document: '007.007.007-07', order_code: 'PQR777', server: server_f)
InstallProduct.create!(customer_document: '008.008.008-08', order_code: 'PQR888', server: server_f)
InstallProduct.create!(customer_document: '009.009.009-09', order_code: 'PQR999', server: server_f)
InstallProduct.create!(customer_document: '010.010.010-10', order_code: 'PQR000', server: server_f)
InstallProduct.create!(customer_document: '011.011.011-11', order_code: 'PQR111', server: server_f)
InstallProduct.create!(customer_document: '012.012.012-12', order_code: 'PQR222', server: server_f)
InstallProduct.create!(customer_document: '100.100.100-00', order_code: 'PQR333', server: server_f)
InstallProduct.create!(customer_document: '100.100.100-00', order_code: 'PQR444', server: server_f)
InstallProduct.create!(customer_document: '100.100.100-00', order_code: 'PQR555', server: server_f)
InstallProduct.create!(customer_document: '100.100.100-00', order_code: 'EFG444', server: server_k)
InstallProduct.create!(customer_document: '100.100.100-00', order_code: 'HIJ777', server: server_l)
