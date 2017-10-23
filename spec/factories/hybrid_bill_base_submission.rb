FactoryGirl.define do 
  factory :hybrid_bill_base_submission do 
    submitter_type 1
    first_name "susan"
    last_name "conkers"
    address_1 "millbank 7"
    address_2 "westminister"
    postcode "WC2 7TL"
    country "UK"
    telephone "0207 520 0890"
    committee_business_id 255
  end
end

