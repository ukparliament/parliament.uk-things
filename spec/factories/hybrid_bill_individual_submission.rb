FactoryBot.define do
  factory :hybrid_bill_individual_submission do
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
    has_a_rep 'false'

    factory :hybrid_bill_individual_submission_with_agent_params do
      has_a_rep 'true'

      hybrid_bill_agent { { first_name: 'jane', second_name: 'smith', address_1: 'House of Commons', address_2: '', postcode: 'SW1A 0AA', country: 'UK', in_the_uk: 'true', telephone: '01234567891', email: 'jane.smith@parliament.uk', receive_updates: '0' } }
    end

    factory :hybrid_bill_individual_submission_with_an_agent do
      has_a_rep 'true'

      hybrid_bill_agent { FactoryBot.build(:hybrid_bill_agent) }
    end
  end
end

