require 'rails_helper'

RSpec.describe HybridBillPetitionAgent, :type => :model do 

	context 'model' do 
		  it "is valid" do 
		    hybrid_bill_petition_agent = build(:hybrid_bill_petition_agent)
		  	expect(hybrid_bill_petition_agent).to be_valid
		  end	

		    it "is invalid" do 
		    hybrid_bill_petition_agent = build(:hybrid_bill_petition_agent, committee_business_id: 100)
		  	expect(hybrid_bill_petition_agent).not_to be_valid
		  end	

	end

end	