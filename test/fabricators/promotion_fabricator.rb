Fabricator(:promotion) do
    name { sequence(:name) { |i| "Namorados#{i}" } }
    description 'Promoção dia dos Namorados'
    code 'NAMORADOS10'
    discount_rate '10'
    coupon_quantity '2'
    expiration_date '13/06/2031'
    user
end