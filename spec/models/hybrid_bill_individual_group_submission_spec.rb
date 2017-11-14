require 'rails_helper'

RSpec.describe HybridBillIndividualGroupSubmission do
  it 'is valid' do
    expect(build(:hybrid_bill_individual_group_submission)).to be_valid
  end

  it 'is invalid' do
    expect(build(:hybrid_bill_individual_group_submission, receive_updates: nil)).not_to be_valid
  end
end

