class PromotionsController < ApplicationController
    before_action :set_promotion, only: [:show, :edit, :update, :destroy, :generate_coupons]
    
    def index
        @promotions = Promotion.all
    end

    def show
    end

    def new
        @promotion = Promotion.new
    end

    def create
        @promotion = Promotion.new(promotion_params)
        if @promotion.save
            redirect_to @promotion
        else
            render :new
        end
    end

    def generate_coupons
        @promotion.generate_coupons!
        redirect_to @promotion, notice: 'Cupons gerados com sucesso'
    end

    def edit
    end

    def update
        if @promotion.update(promotion_params)
            redirect_to @promotion
        else
            render :edit
        end
    end

    def destroy
        @coupons = Coupon.where(promotion: @promotion.id)
        @coupons.each do |coupon|
            coupon.destroy
        end

        @promotion.destroy
        redirect_to @promotion
    end


    private

        def set_promotion
            @promotion = Promotion.find(params[:id])
        end

        def promotion_params
            params
                .require(:promotion)
                .permit(:name,  :expiration_date, :description,
                        :discount_rate, :code, :coupon_quantity)
        end
end