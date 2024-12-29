FactoryBot.define do
  factory :plan do
    name { 'Hospedagem Básica' }
    description { '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis' }
    details { '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada' }
    product_group { create(:product_group) }
    status { :active }
  end
end
