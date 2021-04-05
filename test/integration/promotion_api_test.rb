require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
    test 'show coupon' do
        user = User.create!(email: 'jane.doe@iugu.com.br', password: '123456')
        promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                      code: 'NAMORADOS10', discount_rate: 10, 
                                      coupon_quantity: 2,
                                      expiration_date: '13/06/2031', user: user)
        coupon = Coupon.create!(code: 'NAMORADOS10-0001', promotion: promotion)

        get "/api/v1/coupons/#{coupon.code}", as: :json

        assert_response :success
        # puts response.body; :raise
        body = JSON.parse(response.body, symbolize_names: true)
        assert_equal promotion.discount_rate.to_s, body[:discount_rate]
        # assert_equal coupon.code, response.parsed_body['code']
    end

    test 'show coupon not found' do
        get '/api/v1/coupons/0', as: :json

        assert_response :not_found
    end

    test 'show coupon disabled' do
        user = User.create!(email: 'test@ugu.com.br', password: '123456')
        promotion = Promotion.create!(name: 'Namorados', 
                                      description: 'Promoção dia dos Namorados',
                                      code: 'NAMORADOS10', discount_rate: 10, 
                                      coupon_quantity: 2,
                                      expiration_date: '13/06/2031', user: user)
        coupon = Coupon.create!(code: 'NAMORADOS10-0001', promotion: promotion,
                                status: :disabled)

        get "/api/v1/coupons/#{coupon.code}", as: :json
        assert_response :not_found
    end
end