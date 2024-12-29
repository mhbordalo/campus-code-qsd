module CreationOrderModelCustomerMethods
  extend ActiveSupport::Concern

  def validate_customer_identification
    return unless current_step == 'customer' || current_step == 'customer_data'

    case customer_identification.size
    when 11
      validate_customer_cpf
    when 14
      validate_customer_cnpj
    else
      errors.add(:base, I18n.t('creation_order.msg_invalid_value'))
    end
  end

  def validate_customer_cpf
    errors.add(:base, I18n.t('creation_order.msg_invalid_cpf')) unless customer_cpf?
  end

  def validate_customer_cnpj
    errors.add(:base, I18n.t('creation_order.msg_invalid_cnpj')) unless customer_cnpj?
  end

  def validate_customer_zipcode
    return unless current_step == 'customer_data' && customer_exists == false
    return if customer_zipcode.nil?
    return if customer_zipcode.match?(/\d{5}-\d{3}/)

    errors.add(:customer_zipcode, I18n.t('creation_order.msg_zipcode_wrong_format'))
  end

  def validate_customer_phone
    return unless current_step == 'customer_data' && customer_exists == false
    return if customer_phone.nil?
    return if customer_phone.match?(/\(\d{2}\)\s\d{4,5}-\d{4}/)

    errors.add(:customer_phone, I18n.t('creation_order.msg_phone_wrong_format'))
  end

  def customer_blocklisted?
    return unless current_step == 'customer'

    blocklisted_customer = BlocklistedCustomer.find_by(doc_ident: customer_identification)

    return unless blocklisted_customer

    errors.add(:base, I18n.t('creation_order.msg_customer_blocklisted'))
  end

  def customer_identification_formatted
    case customer_identification.size
    when 11
      cpf = CPF.new(customer_identification)
      cpf.formatted
    when 14
      cnpj = CNPJ.new(customer_identification)
      cnpj.formatted
    end
  end

  def customer_cpf?
    CPF.valid?(customer_identification)
  end

  def customer_cnpj?
    CNPJ.valid?(customer_identification)
  end

  def validate_coupon
    return unless current_step == 'coupon'
    return if coupon_code.nil? || coupon_code == ''

    checking_coupon_validity
  end

  def checking_coupon_validity
    api_result = PaymentService.validate_coupon(create_validate_coupon_data_payload)

    return if api_result[:status] == 'SUCCESS'

    errors.add(:base, api_result[:status_message])
  end

  def create_validate_coupon_data_payload
    { coupon_code: coupon_code.upcase,
      price: product_plan_price,
      product_plan_name: }
  end
end
