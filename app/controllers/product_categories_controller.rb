class ProductCategoriesController < ApplicationController
    def index
        @product_categories = ProductCategory.all
    end

    def show
        @product_category = ProductCategory.find(params[:id])
    end

    def new
        @product_category = ProductCategory.new
    end

    def create
        @product_category = ProductCategory.new(product_params)
        if @product_category.save
            redirect_to @product_category
        else
            render :new
        end
    end

    def edit
        @product_category = ProductCategory.find(params[:id])
    end

    def update
        @product_category = ProductCategory.find(params[:id])

        if @product_category.update(product_params)
            redirect_to @product_category
        else
            render :edit
        end
    end

    def destroy
        @product_category = ProductCategory.find(params[:id])

        @product_category.destroy
        
        redirect_to @product_category
    end

    private

        def product_params
            params
                .require(:product_category)
                .permit(:name, :code)
        end
end