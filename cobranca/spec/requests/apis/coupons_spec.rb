require 'rails_helper'

describe 'Access API' do
  context 'Access GET /api/v1/coupons/validate to validate a coupon' do
    it 'and validates a coupon with success' do
      promo1 = Promotion.create!(name: 'Promo de BlackFriday', start: '2023-01-05',
                                 finish: '2023-03-31', discount: 5,
                                 maximum_discount_value: 250.5,
                                 coupon_quantity: 100,
                                 status: 9, approve_date: '2023-01-01',
                                 approval_date: '2023-01-01', user_create: 1,
                                 user_aprove: 2, code: 'BLACKFRIDAY',
                                 products: ['Produto 1', 'Produto 2'])

      create(:promotion, name: 'Promo Dia das Maes 2023',
                         status: 9, code: 'MOTHERSDAY',
                         products: ['Produto 3', 'Produto 4'])

      Coupon.create!(code: 'BLACKFRIDAY-12345', promotion: promo1, status: 0)

      params = { coupon_code: 'BLACKFRIDAY-12345', price: 1500,
                 product_plan_name: 'Produto 2' }

      get(api_v1_validate_coupon_path, params:)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['coupon_code']).to eq 'BLACKFRIDAY-12345'
      expect(json_response['discount']).to eq 75
      expect(json_response['price']).to eq 1500
      expect(json_response['final_price']).to eq 1425
    end

    it 'and receive error if coupon not found' do
      params = { coupon_code: 'BLACKFRIDAY-12345', price: 1500,
                 product_plan_name: 'Produto 2' }

      get(api_v1_validate_coupon_path, params:)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Nenhum registro encontrado'
    end

    it 'and fails if any required param is missing' do
      params = { coupon_code: 'BLACKFRIDAY-12345',
                 product_plan_name: 'Produto 2' }

      get(api_v1_validate_coupon_path, params:)

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Dados não informados ou incompletos'
    end
  end

  context 'Access POST /api/v1/coupons to use a coupon' do
    it 'and use a coupon with success' do
      promo1 = Promotion.create!(name: 'Promo Fast Start', start: '2023-01-02', finish: '2023-03-31', discount: 5,
                                 maximum_discount_value: 250.5, coupon_quantity: 100, status: 9,
                                 approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                                 user_aprove: 2, code: 'FASTSTART', products: ['Produto 1', 'Produto 2'])
      Coupon.create!(code: 'FASTSTART-12345', promotion: promo1, status: 0)
      order_code = 'MYORDER'
      url = "/api/v1/orders/#{order_code}/discount"
      allow(Faraday).to receive(:post).with(url, { discount: 75.0 }.to_json,
                                            { 'Content-Type' => 'application/json' }).and_return({ status: 200 })

      params = { coupon_code: 'FASTSTART-12345', price: 1500,
                 product_plan_name: 'Produto 2', order_code: }
      post(api_v1_burn_coupon_path, params:)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['code']).to eq 'FASTSTART-12345'
      expect(json_response['price']).to eq 1500
      expect(json_response['discount']).to eq 75
      expect(json_response['final_price']).to eq 1425
      coupon = Coupon.find_by(code: 'FASTSTART-12345')
      expect(coupon.used?).to be true
      expect(coupon.order_code).to eq 'MYORDER'
      expect(coupon.consumption_application).to eq 'Produto 2'
    end

    it 'and receives error trying to use another coupon on same order' do
      promo1 = Promotion.create!(name: 'Promo Fast Start', start: '2023-01-02', finish: '2023-03-31', discount: 5,
                                 maximum_discount_value: 250.5, coupon_quantity: 100, status: 9,
                                 approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                                 user_aprove: 2, code: 'FASTSTART', products: ['Produto 1', 'Produto 2'])
      order_code = 'MYORDER'
      Coupon.create!(code: 'FASTSTART-1000', promotion: promo1, status: 3, order_code:)
      Coupon.create!(code: 'FASTSTART-12345', promotion: promo1, status: 0)
      url = "/api/v1/orders/#{order_code}/discount"
      allow(Faraday).to receive(:post).with(url, { discount: 75.0 }.to_json,
                                            { 'Content-Type' => 'application/json' }).and_return({ status: 200 })

      params = { coupon_code: 'FASTSTART-12345', price: 1500,
                 product_plan_name: 'Produto 2', order_code: }
      post(api_v1_burn_coupon_path, params:)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['error']).to eq 'Cupom inexistente, inválido ou pedido já possui desconto.'
    end

    it 'and receives error message if coupon does not exists' do
      promo1 = Promotion.create!(name: 'Promo Fast Start', start: '2023-01-02', finish: '2023-03-31', discount: 5,
                                 maximum_discount_value: 250.5, coupon_quantity: 100, status: 9,
                                 approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                                 user_aprove: 2, code: 'FASTSTART', products: ['Produto 1', 'Produto 2'])
      Coupon.create!(code: 'FASTSTART-12345', promotion: promo1, status: 3)
      order_code = 'MYORDER'
      url = "/api/v1/orders/#{order_code}/discount"
      allow(Faraday).to receive(:post).with(url, { discount: 75.0 }.to_json,
                                            { 'Content-Type' => 'application/json' }).and_return({ status: 200 })

      params = { coupon_code: 'FASTSTART-12345', price: 1500,
                 product_plan_name: 'Produto 2', order_code: }
      post(api_v1_burn_coupon_path, params:)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['error']).to eq 'Cupom inexistente, inválido ou pedido já possui desconto.'
    end

    it 'and generates an error log if order is not updated with success' do
      promo1 = Promotion.create!(name: 'Promo Fast Start', start: '2023-01-02', finish: '2023-03-31', discount: 5,
                                 maximum_discount_value: 250.5, coupon_quantity: 100, status: 9,
                                 approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                                 user_aprove: 2, code: 'FASTSTART', products: ['Produto 1', 'Produto 2'])
      Coupon.create!(code: 'FASTSTART-12345', promotion: promo1, status: 0)
      order_code = 'MYORDER'
      url = "/api/v1/orders/#{order_code}/discount"
      allow(Rails.logger).to receive(:error)
      allow(Faraday).to receive(:post).with(url, { discount: 75.0 }.to_json,
                                            { 'Content-Type' => 'application/json' }).and_return({ status: 504 })

      params = { coupon_code: 'FASTSTART-12345', price: 1500, product_plan_name: 'Produto 2', order_code: }

      post(api_v1_burn_coupon_path, params:)

      expect(Rails.logger).to have_received(:error).with('ERRO: O desconto de 75.0 não foi gravado no pedido MYORDER')
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['code']).to eq 'FASTSTART-12345'
      expect(json_response['price']).to eq 1500
      expect(json_response['discount']).to eq 75
      expect(json_response['final_price']).to eq 1425
      coupon = Coupon.find_by(code: 'FASTSTART-12345')
      expect(coupon.used?).to be true
      expect(coupon.order_code).to eq 'MYORDER'
      expect(coupon.consumption_application).to eq 'Produto 2'
    end

    it 'and generates an error log if cant connect with chechout API ' do
      promo1 = Promotion.create!(name: 'Promo Fast Start', start: '2023-01-02', finish: '2023-03-31', discount: 5,
                                 maximum_discount_value: 250.5, coupon_quantity: 100, status: 9,
                                 approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                                 user_aprove: 2, code: 'FASTSTART', products: ['Produto 1', 'Produto 2'])
      Coupon.create!(code: 'FASTSTART-12345', promotion: promo1, status: 0)
      order_code = 'MYORDER'
      url = "/api/v1/orders/#{order_code}/discount"
      allow(Rails.logger).to receive(:error)
      allow(Faraday).to receive(:post).with(url, { discount: 75.0 }.to_json, { 'Content-Type' => 'application/json' })
                                      .and_raise(Faraday::ConnectionFailed)

      params = { coupon_code: 'FASTSTART-12345', price: 1500, product_plan_name: 'Produto 2', order_code: }

      post(api_v1_burn_coupon_path, params:)
      error_msg = "ERRO: Falha ao acessar #{url} para gravar o desconto de 75.0 no pedido MYORDER"
      expect(Rails.logger).to have_received(:error).with(error_msg)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['code']).to eq 'FASTSTART-12345'
      expect(json_response['price']).to eq 1500
      expect(json_response['discount']).to eq 75
      expect(json_response['final_price']).to eq 1425
      coupon = Coupon.find_by(code: 'FASTSTART-12345')
      expect(coupon.used?).to be true
      expect(coupon.order_code).to eq 'MYORDER'
      expect(coupon.consumption_application).to eq 'Produto 2'
    end
  end
end
