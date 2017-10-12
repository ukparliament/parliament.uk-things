require_relative '../rails_helper'

RSpec.describe HybridBillTermsSerializer do
  describe '#serialze' do
    let(:petition_id) { 'ABC123456' }

    it 'creates the expected JSON' do
      expect(HybridBillTermsSerializer.serialize(petition_id)).to eq('{"ReferenceNumber":"ABC123456"}')
    end
  end
end
