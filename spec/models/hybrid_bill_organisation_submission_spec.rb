require 'rails_helper'

RSpec.describe HybridBillOrganisationSubmission, :type => :model do 

	context 'model' do 
		  it "is valid" do 
		    hybrid_bill_organisation_model = build(:hybrid_bill_organisation_submission)
		  	expect(hybrid_bill_organisation_model).to be_valid
		  end	

		    it "is invalid" do 
		    hybrid_bill_organisation_model = build(:hybrid_bill_organisation_submission, submitter_type: 17)
		  	expect(hybrid_bill_organisation_model).not_to be_valid
		  end	
	
	end


end	