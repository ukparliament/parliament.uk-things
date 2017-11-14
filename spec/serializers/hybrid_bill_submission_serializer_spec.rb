require_relative '../rails_helper'

RSpec.describe HybridBillSubmissionSerializer do
  describe '#serialze' do
    context 'with required parameters' do
      before :each do
        @submission = build(:hybrid_bill_individual_group_submission)
      end

      let(:committee_business_id) { '1' }

      it 'creates the expected JSON' do
        expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true}}")
      end

      context 'outside the uk' do
        it 'creates the expected JSON' do
          @submission.in_the_uk = 'false'
          @submission.country = 'foo'

          expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"foo\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true}}")
        end
      end

      context 'inside the uk, with an out of uk country' do
        it 'creates the expected JSON' do
          @submission.in_the_uk = 'true'
          @submission.country = 'foo'

          expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true}}")
        end
      end

      context 'without receiving updates' do
        it 'creates the expected JSON' do
          @submission.receive_updates = '0'

          expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":false}}")
        end
      end

      context 'including an agent' do
        before :each do
          @submission = build(:hybrid_bill_individual_group_submission_with_an_agent)
        end

        it 'creates the expected JSON' do
          expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true},\"HybridBillPetitionAgent\":{\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true}}")
        end

        context 'outside the uk' do
          it 'creates the expected JSON' do
            @submission.hybrid_bill_agent.in_the_uk = 'false'
            @submission.hybrid_bill_agent.country = 'foo'

            expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true},\"HybridBillPetitionAgent\":{\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"foo\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true}}")
          end
        end

        context 'inside the uk, with an out of uk country' do
          it 'creates the expected JSON' do
            @submission.hybrid_bill_agent.in_the_uk = 'true'
            @submission.hybrid_bill_agent.country = 'foo'

            expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true},\"HybridBillPetitionAgent\":{\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true}}")
          end
        end

        context 'without receiving updates' do
          it 'creates the expected JSON' do
            @submission.hybrid_bill_agent.receive_updates = '0'

            expect(HybridBillSubmissionSerializer.serialize(committee_business_id, @submission)).to eq("{\"CommitteeBusinessId\":\"1\",\"HybridBillPetitioner\":{\"SubmitterType\":2,\"OnBehalfOf\":\"a group\",\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":true},\"HybridBillPetitionAgent\":{\"FirstName\":\"joe\",\"Surname\":\"conkers\",\"AddressLine1\":\"millbank 1\",\"AddressLine2\":\"westminister\",\"Country\":\"GB\",\"Postcode\":\"WC2 7TL\",\"Email\":\"jconkers@gmail.com\",\"Telephone\":\"0207 520 1234\",\"ReceivesUpdates\":false}}")
          end
        end
      end
    end
  end
end
