require 'rails_helper'
require 'base64'

RSpec.describe HybridBillPetition, :type => :model do 

	context 'model' do 

		context 'decoding' do 
		  it "passes" do 
		    hybrid_bill_petition = build(:hybrid_bill_petition)
		  	expect(Base64.decode64(hybrid_bill_petition.document_data)).to eq("This is a test string")
		  end	

		  it "fails" do 
		    hybrid_bill_petition = build(:hybrid_bill_petition, document_data: "This is a test string")
		  	expect(Base64.decode64(hybrid_bill_petition.document_data)).not_to eq("This is a test string")
		  end	
		end 

		context 'file type' do
		  it "passes" do 
		    hybrid_bill_petition = build(:hybrid_bill_petition)
		  	expect(hybrid_bill_petition).to be_valid
		  end	

		  it "fails" do 
		    hybrid_bill_petition = build(:hybrid_bill_petition, filename: 'thisismydoc.csv')
		  	expect(hybrid_bill_petition).not_to be_valid
		  end
		end  
	
	end


end	