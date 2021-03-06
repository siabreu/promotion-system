class Promotion < ApplicationRecord
    belongs_to :user
    has_many :coupons , dependent: :restrict_with_error
    has_one :promotion_approval
    has_one :approver, through: :promotion_approval, source: :user

    validates :name, :code, :discount_rate, :coupon_quantity, 
              :expiration_date, presence: true
    validates :code, :name, uniqueness: true
    SERARCHABLE_FIELDS = %w[name code description].freeze

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

    # TODO: Trocar para busca Kaminari - faz paginação
    def self.search(query)
        # where('name LIKE ?', "%#{query.downcase}%")
        # pode limitar o total de retorno para 5
        # where('name LIKE ?', "%#{query}%").limit(5)
        where(
            SERARCHABLE_FIELDS
                .map { |field| "#{field} LIKE :query"}
                .join(' OR '),
            query: "%#{query}%"
         ).limit(5)
    end

    def approved?
        promotion_approval.present?
    end

    def can_approve?(current_user)
        user != current_user
    end
end
