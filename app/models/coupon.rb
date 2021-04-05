class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status:  { active: 0, disabled: 10 }
  delegate :discount_rate, to: :promotion

  def as_json(options = {})
    super( { methods: :discount_rate }.merge(options) )
  end

  def self.search(query)
    Coupon.find_by(code: query)
  end
end
