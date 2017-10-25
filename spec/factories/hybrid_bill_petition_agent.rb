FactoryGirl.define do 
  factory :hybrid_bill_petition_agent do 
    first_name "joe"
    last_name "conkers"
    address_1 "millbank 1"
    address_2 "westminister"
    postcode "WC2 7TL"
    country "UK"
    telephone "0207 520 1234"
    email "jconkers@gmail.com"
    receive_updates true
    committee_business_id 1
  end
end