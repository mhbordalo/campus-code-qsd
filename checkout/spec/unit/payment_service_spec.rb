require 'rails_helper'

RSpec.describe PaymentService do
  describe '#coupons' do
    context 'coupon validation' do
      it 'validate' do
        fake_response_validate_coupon = double(api_result_validate_coupon)
        validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
        allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                       .and_return(fake_response_validate_coupon)

        validate_coupon = PaymentService.validate_coupon(validate_coupon_data)
        expect(validate_coupon).to eq({ status: 'SUCCESS',
                                        data: { coupon_code: 'BLACKFRIDAY-AS123', discount: 2.0,
                                                final_price: 78.97, price: 80.97 },
                                        status_message: 'OK' })
      end

      it 'return error from raised exceptions' do
        validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
        allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                       .and_raise(Faraday::TimeoutError)

        validate_coupon = PaymentService.validate_coupon(validate_coupon_data)
        expect(validate_coupon).to eq({ status: 'ERROR_API', data: {}, status_message: 'timeout' })
      end
    end

    context 'coupon burning' do
      it 'burn' do
        fake_response_burn_coupon = double(api_result_burn_coupon)
        burn_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', order_code: 'ABCDE12345', price: '80.97',
                             product_plan_name: 'Hospedagem II' }
        allow(Faraday).to receive(:post).with(url_api_payment_burn_coupon, JSON.generate(burn_coupon_data),
                                              { 'Content-Type' => 'application/json' })
                                        .and_return(fake_response_burn_coupon)

        burn_coupon = PaymentService.burn_coupon(burn_coupon_data)
        expect(burn_coupon).to eq({ status: 'SUCCESS',
                                    data: { coupon_code: 'BLACKFRIDAY-AS123', discount: 2.0,
                                            final_price: 78.97, price: 80.97 },
                                    status_message: 'OK' })
      end

      it 'return error from raised exceptions' do
        burn_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', order_code: 'ABCDE12345', price: '80.97',
                             product_plan_name: 'Hospedagem II' }
        allow(Faraday).to receive(:post).with(url_api_payment_burn_coupon, JSON.generate(burn_coupon_data),
                                              { 'Content-Type' => 'application/json' })
                                        .and_raise(Faraday::TimeoutError)

        burn_coupon = PaymentService.burn_coupon(burn_coupon_data)
        expect(burn_coupon).to eq({ status: 'ERROR_API', data: {}, status_message: 'timeout' })
      end
    end
  end
end
