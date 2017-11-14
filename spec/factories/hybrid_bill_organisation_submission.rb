FactoryBot.define do
  factory :hybrid_bill_organisation_submission do
    first_name 'susan'
    surname 'conkers'
    on_behalf_of 'Group of Organisations'
    address_1 'millbank 7'
    address_2 'westminister'
    postcode 'WC2 7TL'
    country 'GB'
    telephone '0207 520 0890'
    email 'testing@gmail.com'
    receive_updates '1'
    in_the_uk 'true'
    has_a_rep 'false'
  end
end

