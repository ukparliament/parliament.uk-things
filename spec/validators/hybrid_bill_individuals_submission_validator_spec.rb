
require 'rails_helper'

RSpec.describe 'HybridBillIndividualsSubmissionValidator' do 

	context 'for group of individuals path' do 
		  it 'is valid' do 
		      hybrid_bill_grp_of_indiv = build(:hybrid_bill_individuals_submission)
		      expect(hybrid_bill_grp_of_indiv).to be_valid
		  end

		  it 'is invalid' do 
		      hybrid_bill_grp_of_indiv = build(:hybrid_bill_individuals_submission, country: "12")
		      expect(hybrid_bill_grp_of_indiv).not_to be_valid
		  end
	end 
end	
