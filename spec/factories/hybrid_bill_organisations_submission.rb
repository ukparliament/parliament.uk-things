FactoryGirl.define do 
  factory :hybrid_bill_organisations_submission do 
    submitter_type 4
    first_name "susan"
    last_name "conkers"
    on_behalf_of "Group of Organisations"
    address_1 "millbank 7"
    address_2 "westminister"
    postcode "WC2 7TL"
    country "UK"
    telephone "0207 520 0890"
    email "testing@gmail.com"
    receive_updates true
    committee_business_id 1
  end
end

