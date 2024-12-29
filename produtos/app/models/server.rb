class Server < ApplicationRecord
  belongs_to :product_group
  has_many :install_products, dependent: :nullify
  enum operational_system: { linux: 5, windows: 10 }, _default: 10
  enum type_of_storage: { ssd: 5, hd: 10 }, _default: 5

  validates :number_of_cpus, :amount_of_ram, :storage_capacity, :max_installations, presence: true
  validates :number_of_cpus, :amount_of_ram, :storage_capacity, :max_installations,
            numericality: { only_integer: true, greater_than: 0 }

  before_validation :generate_code, on: :create

  def self.more_available_server(plan_name)
    more_available_server_and_its_availability(plan_name).first
  end

  def self.greater_availability(plan_name)
    more_available_server_and_its_availability(plan_name).last
  end

  def self.more_available_server_and_its_availability(plan_name)
    plan = Plan.find_by(name: plan_name)
    plan_servers = plan.product_group.servers
    available_servers = plan_servers.index_with \
      { |server| server.max_installations - server.install_products.active.count }
    available_servers.max_by(&:last)
  end

  private

  def generate_code
    os_prefix = operational_system[0..4].upcase
    group_prefix = product_group.code.upcase
    sufix = SecureRandom.alphanumeric(8).upcase
    self.code = "#{os_prefix}-#{group_prefix}-#{sufix}"
  end
end
