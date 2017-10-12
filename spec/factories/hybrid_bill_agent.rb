FactoryBot.define do
  factory :hybrid_bill_agent do
    first_name 'joe'
    surname 'conkers'
    address_1 'millbank 1'
    address_2 'westminister'
    postcode 'WC2 7TL'
    country 'UK'
    in_the_uk 'true'
    telephone '0207 520 1234'
    email 'jconkers@gmail.com'
    receive_updates '1'
  end
end
