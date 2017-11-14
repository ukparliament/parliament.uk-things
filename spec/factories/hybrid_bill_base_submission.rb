FactoryBot.define do
  factory :hybrid_bill_base_submission do
    first_name 'su'
    surname 'conkers'
    address_1 'millbank 7'
    postcode 'WC2 7TL'
    country 'GB'
    email 'sconkers@gmail.com'
    telephone '0207 520 0890'
    receive_updates '1'
    in_the_uk 'true'
    has_a_rep 'false'
  end
end

