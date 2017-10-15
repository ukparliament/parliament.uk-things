require 'rails_helper'
require 'pry'
require 'pry-nav'

RSpec.describe HybridBill, :type => :model do 

  it "is be valid with an correct committee business id and correct terms and conditions" do 

  	hybrid_bill = HybridBill.new
  	expect(hybrid_bill).to be_valid
  end	

end	