require 'rails_helper'

RSpec.describe HybridBillsController, vcr: false do
  WebMock.disable_net_connect!

  after(:each) do
   Timecop.return
  end

  describe 'GET show' do
    it_behaves_like 'successful show response'
  end  

  before(:each) do
    Timecop.freeze(Time.utc(2017, 12, 1, 12, 0, 1))
  end

  describe 'pre status' do
    let(:stage) {'pre'}
    let(:page)  {'hybrid_bills/pre'}

    it_behaves_like 'the current stage template'
  end

 describe 'post status' do
   let(:stage) {'post'}
   let(:page)  {'hybrid_bills/post'}

   it_behaves_like 'the not current stage template'
  end
end