class Promotion < ApplicationRecord
    has_many :coupons , dependent: :destroy

    validates :name, :code, :discount_rate, :coupon_quantity, 
              :expiration_date, presence: { message: 'não pode ficar em branco' }
    validates :code, :name, uniqueness: { message: 'deve ser único'}

    def generate_coupons!
        return if coupons?

        (1..coupon_quantity).each do |number|
            coupons.create!(code: "#{code}-#{'%04d' % number}")
        end
    end

    # rails notes --para visualizar os todos
    #TODO: fazer testes para esse método
    def coupons? 
        coupons.any?
    end
end
