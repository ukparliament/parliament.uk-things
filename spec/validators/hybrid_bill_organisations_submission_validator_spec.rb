require 'rails_helper'

RSpec.describe 'HybridBillOrganisationsSubmissionValidator' do 

	context 'for group of organisations path' do 
		  it 'is valid' do 
		      hybrid_bill_grp_of_org = build(:hybrid_bill_organisations_submission)
		      expect(hybrid_bill_grp_of_org).to be_valid
		  end

		  it 'is invalid' do 
		      hybrid_bill_grp_of_org = build(:hybrid_bill_organisations_submission, country: "12")
		      expect(hybrid_bill_grp_of_org).not_to be_valid
		  end
	end 
end	
