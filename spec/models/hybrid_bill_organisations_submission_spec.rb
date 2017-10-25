require 'rails_helper'

RSpec.describe HybridBillOrganisationsSubmission, :type => :model do 

	context 'model' do 
		  it "is valid" do 
		    hybrid_bill_grp_of_org_model = build(:hybrid_organisations_submission)
		  	expect(hybrid_bill_grp_of_org_model).to be_valid
		  end	

		    it "is invalid" do 
		    hybrid_bill_grp_of_org_model = build(:hybrid_organisations_submission, submitter_type: 17)
		  	expect(hybrid_bill_grp_of_org_model).not_to be_valid
		  end	
	end

end	