class PromotionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_promotion, only: %i[show edit update destroy 
                                           generate_coupons approve]

    def index
        @promotions = Promotion.all
    end

    def show
    end

    def new
        @promotion = Promotion.new
    end

    def create
        @promotion = current_user.promotions.new(promotion_params)
        if @promotion.save
            redirect_to @promotion
        else
            render :new
        end
    end

    def generate_coupons
        @promotion.generate_coupons!
        redirect_to @promotion, notice: t('.success')
    end

    def edit
    end

    def update
        return redirect_to @promotion if @promotion.update(promotion_params)

        render :edit
    end

    def destroy
        # @coupons = Coupon.where(promotion: @promotion.id)
        # @coupons.each do |coupon|
        #     coupon.destroy
        # end

        if @promotion.destroy
            redirect_to promotions_path, notice: t('.success')
        else
            redirect_to @promotion, notice: t('.failed')
        end
    end

    def search
        @promotions = Promotion.search(params[:q])
        render :index
    end

    def approve
        PromotionApproval.create!(promotion: @promotion, user: current_user)
        redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
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