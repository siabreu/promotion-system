require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
    test 'disable a coupon' do
        user = login_user
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 10, 
                                      coupon_quantity: 3,
                                      expiration_date: '22/12/2033', user: user)
        # coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
        promotion.generate_coupons!

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

    test 'search coupon by code and find result' do
        user = login_user
        cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                        description: 'Promoção de Cyber Monday',
                                        code: 'CYBER15', discount_rate: 15,
                                        expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'CYBER15-0002', promotion: cyber_monday)
        result = Coupon.search(coupon.code)


        visit root_path
        click_on 'Cupons'
        fill_in 'Busca', with: 'CYBER15-0002'
        click_on 'Buscar'

        assert_text coupon.promotion.name
      end
end