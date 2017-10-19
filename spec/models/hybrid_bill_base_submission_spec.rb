require 'rails_helper'

RSpec.describe HybridBillBaseSubmission, :type => :model do 

  it "is valid" do 
    hybrid_bill_base_model = build(:hybrid_bill_base_submission)
  	expect(hybrid_bill_base_model).to be_valid
  end	

end	