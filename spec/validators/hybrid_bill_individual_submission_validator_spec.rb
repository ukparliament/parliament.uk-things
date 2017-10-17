require 'pry'
require 'pry-nav'
require 'rails_helper'


RSpec.describe 'HybridBilllIndividualSubmissionValidator' do 

	describe 'valid instance' do 
		
		           it 'is valid' do 
		           	hybridbillindividual = build_stubbed(:hybrid_bill_individual_submission)
			#subject { hybridbillindividual }
		           	  expect(hybridbillindividual).to be_valid
		           end
	 end   

	 # describe 'invalid instance' do 
		# hybridbillindividual = build_stubbed(:hybridbillindividualsubmission, should_be_contacted: nil)
		# 	subject { hybridbillindividual }
		#           it 'is invalid' do 
		#            	 expect(subject).not_to be_valid
		#           end
	 # end 
end	
