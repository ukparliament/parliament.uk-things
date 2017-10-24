require_relative '../rails_helper'

RSpec.describe HybridBillSubmissionSerializer do
  describe '#serialze' do
    context 'with required parameters' do
      let(:committee_business_id) { '1' }
      let(:petitioner_object) do
        double(
          'submission',
          submitter_type: 1,
          on_behalf_of: 'Parliamentary Digital Service',
          first_name: 'Matthew',
          surname: 'Rayner',
          address_1: '7 Milbank',
          address_2: 'London',
          country: 'gb',
          postcode: 'SW1P 3JA',
          email: 'admin@example.com',
          telephone: '012345678910',
          should_be_contacted: false,
        )
      end

      it 'creates the expected JSON' do
        expect(HybridBillSubmissionSerializer.serialize(committee_business_id, petitioner_object, agent_object: nil)).to eq('{"CommitteeBusinessId":"1","HybridBillPetitioner":{"SubmitterType":1,"OnBehalfOf":"Parliamentary Digital Service","FirstName":"Matthew","Surname":"Rayner","AddressLine1":"7 Milbank","AddressLine2":"London","Country":"gb","Postcode":"SW1P 3JA","Email":"admin@example.com","Telephone":"012345678910","ShouldBeContacted":false}}')
      end

      context 'including an agent' do
        let(:agent_object) do
          double(
            'agent',
            first_name: 'Jamie',
            surname: 'Tetlow',
            address_1: 'House of Commons',
            address_2: nil,
            country: 'gb',
            postcode: 'SW1A 0AA',
            email: 'test@example.com',
            telephone: '123456789101',
            receives_updates: true,
          )
        end

        it 'creates the expected JSON' do
          expect(HybridBillSubmissionSerializer.serialize(committee_business_id, petitioner_object, agent_object:agent_object)).to eq('{"CommitteeBusinessId":"1","HybridBillPetitioner":{"SubmitterType":1,"OnBehalfOf":"Parliamentary Digital Service","FirstName":"Matthew","Surname":"Rayner","AddressLine1":"7 Milbank","AddressLine2":"London","Country":"gb","Postcode":"SW1P 3JA","Email":"admin@example.com","Telephone":"012345678910","ShouldBeContacted":false},"HybridBillPetitionAgent":{"FirstName":"Jamie","Surname":"Tetlow","AddressLine1":"House of Commons","AddressLine2":null,"Country":"gb","Postcode":"SW1A 0AA","Email":"test@example.com","Telephone":"123456789101","ReceivesUpdates":true}}')
        end
      end
    end
  end
end
