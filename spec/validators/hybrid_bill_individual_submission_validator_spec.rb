
require 'rails_helper'

RSpec.describe 'HybridBillIndividualSubmissionValidator' do 

	context 'for individual path' do 
		  it 'is valid' do 
		      hybridbillindividual = build(:hybrid_bill_individual_submission)
		      expect(hybridbillindividual).to be_valid
		  end

		  it 'is invalid' do 
		      hybridbillindividual = build(:hybrid_bill_individual_submission, country: "12")
		      expect(hybridbillindividual).not_to be_valid
		  end
	 end 
end	
