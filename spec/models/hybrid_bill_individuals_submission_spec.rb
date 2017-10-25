require 'rails_helper'

RSpec.describe HybridBillIndividualsSubmission, :type => :model do 

	context 'model' do 
		  it "is valid" do 
		    hybrid_bill_grp_of_indiv_model = build(:hybrid_bill_individuals_submission)
		  	expect(hybrid_bill_grp_of_indiv_model).to be_valid
		  end	

		    it "is invalid" do 
		    hybrid_bill_grp_of_indiv_model = build(:hybrid_bill_individuals_submission, submitter_type: 17)
		  	expect(hybrid_bill_grp_of_indiv_model).not_to be_valid
		  end	
	end


end	