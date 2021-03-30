require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase       #Arrange / Act / Assert
  test 'view promotions' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    # assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'update promotion' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                  code: 'NAMORADOS10', discount_rate: 10, 
                                  coupon_quantity: 60,
                                  expiration_date: '12/06/2032')

    login_user
    visit promotion_path(promotion)
    click_on 'Editar'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Editar promoção'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'update and attributes cannot be blank' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                  code: 'NAMORADOS10', discount_rate: 10, 
                                  coupon_quantity: 60,
                                  expiration_date: '12/06/2032')
    login_user
    visit promotion_path(promotion)
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Editar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'update and code/name must be unique' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                  code: 'NAMORADOS10', discount_rate: 10, 
                                  coupon_quantity: 60,
                                  expiration_date: '12/06/2032')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    click_on 'Editar'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    click_on 'Editar promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'remove promotion' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                        code: 'NAMORADOS10', discount_rate: 10, 
                        coupon_quantity: 2,
                        expiration_date: '13/06/2021')

    login_user
    visit promotion_path(promotion)
    assert_difference 'Promotion.count', -1 do
      accept_confirm { click_on 'Apagar' }
      assert_text 'Promoção apagada com sucesso'
    end
    assert_text 'Nenhuma promoção cadastrada'
    assert_no_text 'Namorados'
    assert_no_text 'Promoção dia dos Namorados'
  end

  test 'cannot remove promotion with coupons' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                  code: 'NAMORADOS10', discount_rate: 10, 
                                  coupon_quantity: 2,
                                  expiration_date: '13/06/2021')
    promotion.generate_coupons!

    login_user
    visit promotion_path(promotion)
    accept_confirm { click_on 'Apagar' }

    assert_text 'Promoção não pode ser apagada'
    assert_text 'Namorados'
  end

  test 'generate coupons for a promotion' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001 (Ativo)'
    assert_text 'NATAL10-0002 (Ativo)'
    assert_text 'NATAL10-0100 (Ativo)'
    assert_no_text 'NATAL10-0101'
    assert_link 'Desabilitar', count: 100
  end

  test 'search promotions by term and finds results' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção Natalina',
                                    code: 'NATALINA10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033')

    result = Promotion.search('natal')
    
    login_user
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text christmassy.name
    refute_text cyber_monday.name
  end

  # TODO: não encontra nada
  # TODO: visit página sem estar logado
  # visit search_promotions(q: 'natal')

  test 'do not view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'do not view promotions using route without login' do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'do view promotion details without login' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                  code: 'NAMORADOS10', discount_rate: 10, 
                                  coupon_quantity: 2,
                                  expiration_date: '13/06/2021')

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not create promotion without login' do
    visit new_promotion_path
    assert_current_path new_user_session_path
  end
end