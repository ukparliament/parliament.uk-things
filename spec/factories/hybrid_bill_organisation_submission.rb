FactoryBot.define do
  factory :hybrid_bill_organisation_submission do
    on_behalf_of 'Toys Company'
    first_name 'susan'
    surname 'conkers'
    address_1 'millbank 7'
    address_2 'westminister'
    postcode 'WC2 7TL'
    country 'UK'
    telephone '0207 520 0890'
    email 'testing@gmail.com'
    receive_updates true
  end
end

