require 'rails_helper'

RSpec.describe HybridBillDocument do
  it 'is valid' do
    expect(build(:hybrid_bill_document)).to be_valid
  end

  context 'invalid factory' do
    it 'is invalid' do
      expect(build(:hybrid_bill_document_with_invalid_file)).not_to be_valid
    end

    it 'has the expected errors' do
      object = build(:hybrid_bill_document_with_invalid_file)
      object.valid?

      expect(object.errors.full_messages).to eq(['Filename unrecognised file', 'Filesize must be less than 2150000'])
    end
  end
end
