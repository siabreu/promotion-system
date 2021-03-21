require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    # Arrange
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    #Act
    visit root_path
    click_on 'Promoções'

    # Assert
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
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    # fill_in 'Data de término', with: '22/12/2033'.to_date
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
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

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar promoção'

    assert_text 'deve ser único', count: 2
  end

  test 'generate coupons for a promotion' do
    #Arrange
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    #Act
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    #Assert
    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0002'
    assert_text 'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
  end

  test 'update promotion' do
    #Arrange
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                                  code: 'NAMORADOS10', discount_rate: 10, 
                                  coupon_quantity: 60,
                                  expiration_date: '13/06/2021')
    #Act
    visit promotion_path(promotion)
    click_on 'Editar promoção'
    fill_in 'Nome', with: 'Namorados'
    fill_in 'Descrição', with: 'Promoção dia dos Namorados'
    fill_in 'Código', with: 'NAMORADOS10'
    fill_in 'Desconto', with: '10'
    fill_in 'Quantidade de cupons', with: '60'    
    fill_in 'Data de término', with: '13/06/2021'
    click_on 'Editar promoção'

    #Assert
    assert_current_path promotion_path(Promotion.last)
    assert_text 'Namorados'
    assert_text 'Promoção dia dos Namorados'
    assert_text '10,00%'
    assert_text 'NAMORADOS10'
    assert_text '13/06/2021'
    assert_text '60'
  end

  test 'remove promotion' do
    promotion = Promotion.create!(name: 'Namorados', description: 'Promoção dia dos Namorados',
                        code: 'NAMORADOS10', discount_rate: 10, 
                        coupon_quantity: 2,
                        expiration_date: '13/06/2021')

    visit promotion_path(promotion)

    click_on 'Excluir promoção'

    assert_current_path promotions_path
  end

end