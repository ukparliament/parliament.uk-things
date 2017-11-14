require 'rails_helper'

RSpec.describe HybridBillIndividualGroupSubmission do
  it 'is valid' do
    expect(build(:hybrid_bill_individual_group_submission)).to be_valid
  end
end
