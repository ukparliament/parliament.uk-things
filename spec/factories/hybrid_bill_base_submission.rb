FactoryGirl.define do 
  factory :hybrid_bill_base_submission do 
    first_name "susan"
    last_name "conkers"
    address_1 "millbank 7"
    address_2 "westminister"
    postcode "WC2 7TL"
    county "london"
    country "UK"
    email "sconkers@gmail.com"
    telephone "0207 520 0890"
    has_agent true
    should_be_contacted false
    committee_business_id 255
  end
end

