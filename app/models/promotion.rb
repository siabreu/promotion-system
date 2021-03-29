class Promotion < ApplicationRecord
    has_many :coupons , dependent: :restrict_with_error

    validates :name, :code, :discount_rate, :coupon_quantity, 
              :expiration_date, presence: true
    validates :code, :name, uniqueness: true

    def generate_coupons!
        return if coupons?

        (1..coupon_quantity).each do |number|
            coupons.create!(code: "#{code}-#{'%04d' % number}")
        end
    end

    #TODO: fazer testes para esse método
    def coupons? 
        coupons.any?
    end

    def self.search(query)
        where('name LIKE ?', "%#{query.downcase}%")
        # TODO: Trocar para busca Kaminari - faz paginação
        # pode limitar o total de retorno para 5
        # where('name LIKE ?', "%#{query}%").limit(5)
    end
end
