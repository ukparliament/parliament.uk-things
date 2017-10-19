require 'rails_helper'

RSpec.describe HybridBillIndividualSubmission, :type => :model do 

	context 'model' do 
		  it "is valid" do 
		    hybrid_bill_individual_model = build(:hybrid_bill_individual_submission)
		  	expect(hybrid_bill_individual_model).to be_valid
		  end	

		    it "is invalid" do 
		    hybrid_bill_individual_model = build(:hybrid_bill_individual_submission, should_be_contacted: nil)
		  	expect(hybrid_bill_individual_model).not_to be_valid
		  end	
	end


end	