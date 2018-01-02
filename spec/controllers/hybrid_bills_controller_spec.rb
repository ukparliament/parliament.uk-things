require 'rails_helper'

RSpec.describe HybridBillsController, vcr: false do
  WebMock.disable_net_connect!

  after(:each) do
   Timecop.return
  end

  describe 'GET show' do
    it_behaves_like 'successful show response'

    describe 'submitted bill id' do 
      it_behaves_like 'a correct bill id'
    end

    describe 'submitted incorrect bill id' do 
      it_behaves_like 'an incorrect bill id'
    end

    context 'pre status' do
      before(:each) do
        Timecop.freeze(Time.utc(2017, 12, 1, 12, 0, 1))
      end

      it_behaves_like 'the expected hybrid bill stage', '1234', 'pre', 'hybrid_bills/pre'
    end

    context 'active status' do
      before(:each) do
        Timecop.freeze(Time.utc(2018, 1, 6, 12, 0, 1))
      end

      it_behaves_like 'the expected hybrid bill stage', '1234', 'active', 'hybrid_bills/show'
    end

    context 'post status' do
      before(:each) do
        Timecop.freeze(Time.utc(2020, 1, 1, 12, 0, 1))
      end

      it_behaves_like 'the expected hybrid bill stage', '1234', 'post', 'hybrid_bills/post'
    end

    context 'closed status' do
      before(:each) do
        Timecop.freeze(Time.utc(2020, 1, 2, 12, 0, 1))
      end

      it 'redirects as expected' do
        expect(get :show, params: { bill_id: '1234' }).to redirect_to(hybrid_bills_path)
      end
    end
  end
end
