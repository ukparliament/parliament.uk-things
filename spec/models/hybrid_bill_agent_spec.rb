require 'rails_helper'

RSpec.describe HybridBillAgent do
	  it 'is valid' do
	    expect(build(:hybrid_bill_agent)).to be_valid
	  end

	  it 'is invalid' do
	    expect(build(:hybrid_bill_agent, email: 'jconke@@gmail.com')).not_to be_valid
	  end
end
