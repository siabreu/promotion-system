require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
    test 'view product categories' do
        #Arrange
        ProductCategory.create!(name: 'Produto AntiFraude',
                                code: 'ANTIFRA')
        ProductCategory.create!(name: 'Produto Trial',
                                code: 'TRIAL')
        
        #Act
        visit root_path
        click_on 'Categorias de produtos'

        #Assert
        assert_text 'Produto AntiFraude'
        assert_text 'ANTIFRA'
    end

    test 'no product category are available' do
        visit root_path
        click_on 'Categorias de produtos'
    
        assert_text 'Nenhuma categoria de produto cadastrada'
    end

    test 'view product categories and return to home page' do
        ProductCategory.create!(name: 'Produto AntiFraude',
                                code: 'ANTIFRA')

        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Voltar'

        assert_current_path root_path
    end


    test 'create product category' do
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: 'Produto AntiFraude'
        fill_in 'Código', with: 'ANTIFRA'        
        click_on 'Criar categoria'

        assert_current_path product_category_path(ProductCategory.last)
        assert_text 'Produto AntiFraude'
        assert_text 'ANTIFRA'
        assert_link 'Voltar'
    end

    test 'create and attibutes cannot be blank' do
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Registrar uma categoria de produto'
        click_on 'Criar categoria de produto'

        assert_text 'não pode ficar em branco', count: 2
    end

    test 'create code must be unique' do
        ProductCategory.create!(name: 'Produto AntiFraude',
                                code: 'ANTIFRA')
        
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: 'Produto AntiFraude'
        fill_in 'Código', with: 'ANTIFRA'
        click_on 'Criar categoria de produto'

        assert_text 'deve ser único', count: 1
    end

    test 'update product category' do
        product_category = ProductCategory.create!(name: 'Produto AntiVirus',
            code: 'ANTIVIRUS')

        visit product_category_path(product_category)
        click_on 'Editar categoria de produto'
        fill_in 'Nome', with: 'Produto AntiVirus'
        fill_in 'Código', with: 'ANTIVIRUS'
        click_on 'Editar categoria de produto'

        assert_current_path product_category_path(ProductCategory.last)
        assert_text 'Produto AntiVirus'
        assert_text 'ANTIVIRUS'
    end

    test 'remove product category' do
        product_category = ProductCategory.create!(name: 'Produto AntiVirus',
            code: 'ANTIVIRUS')

        visit product_category_path(product_category)
        click_on 'Excluir categoria de produto'

        # accept_confirm do
        #   click_on 'Ok'
        # end

        assert_current_path product_categories_path
    end
end