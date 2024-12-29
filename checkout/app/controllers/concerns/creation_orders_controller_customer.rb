module CreationOrdersControllerCustomer
  extend ActiveSupport::Concern

  def search_customer
    @api_result = CustomerService.get_customer(@creation_order.customer_identification)

    if @api_result[:status] == 'SUCCESS'
      @customer = @api_result[:data]
      @creation_order.customer_exists = true
      set_customer_data
    else
      check_api_other_results
    end

    set_session_customer_flags
  end

  def check_api_other_results
    flash[:alert] = @api_result[:status_message] if @api_result[:status] == 'ERROR_API'
    flash[:notice] = @api_result[:status_message] if @api_result[:status] == 'NOT_FOUND'

    @creation_order.customer_exists = false
    @creation_order.customer_data_sent = false
  end

  def set_session_customer_flags
    session_merge({ customer_exists: @creation_order.customer_exists,
                    customer_data_sent: @creation_order.customer_data_sent })
  end

  def clear_creation_order_customer_data
    @creation_order.customer_name = ''
    @creation_order.customer_email = ''
    @creation_order.customer_address = ''
    @creation_order.customer_city = ''
    @creation_order.customer_state = ''
    @creation_order.customer_zipcode = ''
    @creation_order.customer_phone = ''
    @creation_order.customer_birthdate = ''
    @creation_order.customer_corporate_name = ''
  end

  def set_customer_data
    return unless @creation_order.customer_exists

    set_creation_order_customer_data
    set_session_customer_data
  end

  # rubocop:disable Metrics/AbcSize
  def set_creation_order_customer_data
    @creation_order.customer_name = @customer[:name]
    @creation_order.customer_email = @customer[:email]
    @creation_order.customer_address = @customer[:address]
    @creation_order.customer_city = @customer[:city]
    @creation_order.customer_state = @customer[:state]
    @creation_order.customer_zipcode = @customer[:zipcode]
    @creation_order.customer_phone = @customer[:phone]
    @creation_order.customer_birthdate = @customer[:birthdate]
    @creation_order.customer_corporate_name = @customer[:corporate_name]
  end
  # rubocop:enable Metrics/AbcSize

  def set_session_customer_data
    customer_params = { customer_name: @customer[:name],
                        customer_email: @customer[:email],
                        customer_address: @customer[:address],
                        customer_city: @customer[:city],
                        customer_state: @customer[:state],
                        customer_zipcode: @customer[:zipcode],
                        customer_phone: @customer[:phone],
                        customer_birthdate: @customer[:birthdate],
                        customer_corporate_name: @customer[:corporate_name] }

    session_merge(customer_params)
  end

  def send_customer_data_via_api
    customer_data = create_customer_data_payload

    @api_result = CustomerService.save_customer(customer_data)

    if @api_result[:status] == 'SUCCESS'
      flash[:notice] = I18n.t('creation_order.msg_customer_data_sent_ok')
      @creation_order.customer_data_sent = @creation_order.customer_exists = true
      set_session_customer_flags
      return
    end

    assemble_customer_error_message
  end

  def create_customer_data_payload
    customer_data_payload = { identification: @creation_order.customer_identification,
                              name: @creation_order.customer_name,
                              address: @creation_order.customer_address,
                              city: @creation_order.customer_city,
                              state: @creation_order.customer_state,
                              zip_code: @creation_order.customer_zipcode,
                              email: @creation_order.customer_email,
                              phone_number: @creation_order.customer_phone.ljust(16) }

    customer_data_payload.merge!(aditional_customer_data_payload)
    customer_data_payload
  end

  def aditional_customer_data_payload
    if @creation_order.customer_cpf?
      { birthdate: @creation_order.customer_birthdate }
    else
      { corporate_name: @creation_order.customer_corporate_name }
    end
  end

  def assemble_customer_error_message
    flash[:alert] = [I18n.t('creation_order.msg_customer_api_error')]
    flash[:alert] << @api_result[:status_message] if @api_result[:status] == 'ERROR_API'
    @creation_order.no_error_found = false
  end
end
