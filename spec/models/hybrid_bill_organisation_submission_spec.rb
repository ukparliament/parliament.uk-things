require 'rails_helper'

RSpec.describe HybridBillOrganisationSubmission do
  it 'is valid' do
    expect(build(:hybrid_bill_organisation_submission)).to be_valid
  end
end
