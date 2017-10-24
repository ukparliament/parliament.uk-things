require_relative '../rails_helper'

RSpec.describe HybridBillDocumentSerializer do
  describe '#serialze' do
    let(:petition_id) { 'ABC123456' }
    let(:terms) { true }

    it 'creates the expected JSON' do
      expect(HybridBillTermsSerializer.serialize(petition_id, terms)).to eq('{"HybridBillPetitionId":"ABC123456","AcceptedTerms":true}')
    end
  end
end
