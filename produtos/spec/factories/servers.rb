FactoryBot.define do
  factory :server do
    code { 'MyString' }
    operational_system { 'MyString' }
    os_version { 'MyString' }
    number_of_cpus { 1 }
    storage_capacity { 1 }
    type_of_storage { 'MyString' }
    amount_of_ram { 1 }
    max_installations { 1 }
  end
end
