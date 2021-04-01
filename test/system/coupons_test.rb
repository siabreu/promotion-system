require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
    test 'disable a coupon' do
        user = User.create!(email: 'jane.doe@iugu.com.br', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 10, 
                                      coupon_quantity: 3,
                                      expiration_date: '22/12/2033', user: user)
        # coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
        promotion.generate_coupons!

        login_user
        visit promotion_path(promotion)
        within 'div#coupon-natal10-0001' do
            click_on 'Desabilitar'
        end

        assert_text "Cupom NATAL10-0001 desabilitado com sucesso"
        within 'div#coupon-natal10-0001' do
            assert_text "NATAL10-0001 (Desabilitado)"
            assert_no_link 'Desabilitar'
        end
        assert_link 'Desabilitar', count: promotion.coupon_quantity - 1
        # assert_text "Cupom #{coupon.code} desabilitado com sucesso"
        # assert_text "#{coupon.code} (Desabilitado)"
        # assert_no_link 'Desabilitar'
    end
end