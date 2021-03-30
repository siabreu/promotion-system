require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
    test 'view product categories' do
        ProductCategory.create!(name: 'Produto AntiFraude',
                                code: 'ANTIFRA')
        ProductCategory.create!(name: 'Produto Trial',
                                code: 'TRIAL')

        login_user
        visit root_path
        click_on 'Categorias de produtos'

        #Assert
        assert_text 'Produto AntiFraude'
        assert_text 'ANTIFRA'
    end

    test 'no product category are available' do
        login_user
        visit root_path
        click_on 'Categorias de produtos'

        assert_text 'Nenhuma categoria de produto cadastrada'
    end

    test 'view product categories and return to home page' do
        ProductCategory.create!(name: 'Produto AntiFraude',
                                code: 'ANTIFRA')

        login_user
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Voltar'

        assert_current_path root_path
    end


    test 'create product category' do
        login_user
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: 'Produto AntiFraude'
        fill_in 'Código', with: 'ANTIFRA'        
        click_on 'Criar Categoria de Produto'

        assert_current_path product_category_path(ProductCategory.last)
        assert_text 'Produto AntiFraude'
        assert_text 'ANTIFRA'
        assert_link 'Voltar'
    end

    test 'create and attibutes cannot be blank' do
        login_user
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Registrar uma categoria de produto'
        click_on 'Criar Categoria de Produto'

        assert_text 'não pode ficar em branco', count: 2
    end

    test 'create code must be unique' do
        ProductCategory.create!(name: 'Produto AntiFraude',
                                code: 'ANTIFRA')

        login_user
        visit root_path
        click_on 'Categorias de produtos'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: 'Produto AntiFraude'
        fill_in 'Código', with: 'ANTIFRA'
        click_on 'Criar Categoria de Produto'

        assert_text 'já está em uso', count: 1
    end

    test 'update product category' do
        product_category = ProductCategory.create!(name: 'Produto AntiVirus',
            code: 'ANTIVIRUS')

        login_user
        visit product_category_path(product_category)
        click_on 'Editar'
        fill_in 'Nome', with: 'Produto AntiVirus'
        fill_in 'Código', with: 'ANTIVIRUS'
        click_on 'Atualizar Categoria de Produto'

        assert_current_path product_category_path(ProductCategory.last)
        assert_text 'Produto AntiVirus'
        assert_text 'ANTIVIRUS'
    end

    test 'remove product category' do
        product_category = ProductCategory.create!(name: 'Produto AntiVirus',
                                                   code: 'ANTIVIRUS')

        login_user
        visit product_category_path(product_category)
        assert_difference 'ProductCategory.count', -1 do
            accept_confirm { click_on 'Apagar' }
            assert_text 'Categoria apagada com sucesso'
        end
        assert_text 'Nenhuma categoria de produto cadastrada'
        assert_no_text 'Produto AntiVirus'
    end
end