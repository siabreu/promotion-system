class CouponsController < ApplicationController
    def disable
        @coupon = Coupon.find(params[:id])
        @coupon.disabled!
        redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
    end

    def search
        @coupon = Coupon.search(params[:q])
    end
end