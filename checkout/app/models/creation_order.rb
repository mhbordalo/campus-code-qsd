require 'cpf_cnpj'

class CreationOrder
  include ActiveModel::Model
  include CreationOrderModelCustomerMethods

  attr_accessor :customer_exists, :customer_identification, :customer_name, :customer_address, :customer_city,
                :customer_state, :customer_zipcode, :customer_email, :customer_phone, :customer_birthdate,
                :customer_corporate_name, :product_group_form, :product_group_id, :product_group_name,
                :product_plan_form, :product_plan_id, :product_plan_name, :product_price_form,
                :product_plan_periodicity_id, :product_plan_periodicity, :product_plan_price,
                :coupon_code, :discount, :no_error_found, :customer_data_sent

  attr_writer :current_step

  validates :customer_identification, presence:
            { if: ->(o) { o.current_step == 'customer' } }
  validate  :validate_customer_identification
  validate  :customer_blocklisted?

  validates :customer_identification, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_name, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_address, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_city, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_state, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_zipcode, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validate  :validate_customer_zipcode
  validates :customer_email, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_phone, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validate  :validate_customer_phone
  validates :customer_birthdate, presence:
            { if: lambda { |o|
                    o.current_step == 'customer_data' &&
                      o.customer_exists == false &&
                      o.customer_cpf?
                  } }
  validates :customer_corporate_name, presence:
            { if: lambda { |o|
                    o.current_step == 'customer_data' &&
                      o.customer_exists == false &&
                      o.customer_cnpj?
                  } }
  validates :product_group_form, presence:
            { if: ->(o) { o.current_step == 'products' && o.no_error_found } }
  validates :product_plan_form, presence:
            { if: ->(o) { o.current_step == 'plans' && o.no_error_found } }
  validates :product_price_form, presence:
            { if: ->(o) { o.current_step == 'prices' && o.no_error_found } }
  validate  :validate_coupon

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[customer customer_data products plans prices coupon confirmation]
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step) - 1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end
end
