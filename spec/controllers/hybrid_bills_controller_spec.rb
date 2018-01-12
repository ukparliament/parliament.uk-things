require 'rails_helper'

RSpec.describe HybridBillsController, vcr: false do
  WebMock.disable_net_connect!

  describe 'GET show' do
    before :each do
      stub_const('HybridBill::HYBRID_BILLS',{'1234' => ::HybridBill.new(Time.utc(2017, 12, 1, 12, 0, 0), Time.utc(2017, 12, 2, 12, 0, 0), Time.utc(2017, 12, 3, 12, 0, 0), Time.utc(2017, 12, 4, 12, 0, 0))})
    end

    before :each do
      Timecop.freeze(Time.utc(2017, 12, 2, 12, 0, 1))
    end

    after :each do
      Timecop.return
    end

    it 'responds with a 200 status code' do
      get :show, params: { bill_id: '1234' }

      expect(response).to have_http_status(200)
    end

    describe 'submitted bill id' do 
      it_behaves_like 'a correct bill id'
    end

    describe 'submitted incorrect bill id' do 
      it_behaves_like 'an incorrect bill id'
    end

    describe 'subission steps' do
      context 'writing-your-petition-online' do
        it_behaves_like 'a hybrid bill simple step', '1234', 'writing-your-petition-online'
      end

      context 'petition-online' do
        it_behaves_like 'a hybrid bill simple step', '1234', 'petition-online'
      end

      context 'details' do
        context 'individual' do
          it_behaves_like 'a hybrid bill cover page form', '1234', 'details', 'individual'
        end

        context 'individualgroup' do
          it_behaves_like 'a hybrid bill cover page form', '1234', 'details', 'individualgroup'
        end
        
        context 'organisation' do
          it_behaves_like 'a hybrid bill cover page form', '1234', 'details', 'organisation'
        end
        
        context 'organisationgroup' do
          it_behaves_like 'a hybrid bill cover page form', '1234', 'details', 'organisationgroup'
        end
      end

      context 'document-submission' do
        it
      end

      context 'terms-conditions' do
        it
      end

      context 'submission-complete' do
        it
      end
    end

    describe 'hybrid_bill_submission session' do
      it
    end

    describe 'loading hybrid bill models' do
      it
    end

    describe 'status changes' do
      context 'pre status' do
        it_behaves_like 'the expected hybrid bill stage', '1234', 'pre', 'hybrid_bills/pre'
      end

      context 'active status' do
        it_behaves_like 'the expected hybrid bill stage', '1234', 'active', 'hybrid_bills/show'
      end

      context 'post status' do
        it_behaves_like 'the expected hybrid bill stage', '1234', 'post', 'hybrid_bills/post'
      end

      context 'closed status' do
        it 'redirects as expected' do
          expect(get :show, params: { bill_id: '1234', status: 'closed' }).to redirect_to(hybrid_bills_path)
        end
      end

      context 'unexpected status' do
        it 'raises a ActionController::RoutingError' do
          expect { get :show, params: { bill_id: '1234', status: 'foo' } }.to raise_error(ActionController::RoutingError, 'The status foo was not expected.')
        end
      end

      describe 'changes over time' do
        context 'with the date set for pre phase' do
          before :each do
            Timecop.freeze(Time.utc(2017, 12, 1, 12, 0, 1))
          end

          it_behaves_like 'the expected hybrid bill stage', '1234', false, 'hybrid_bills/pre'
        end

        context 'with the date set for active phase' do
          before :each do
            Timecop.freeze(Time.utc(2017, 12, 2, 12, 0, 1))
          end

          it_behaves_like 'the expected hybrid bill stage', '1234', false, 'hybrid_bills/show'
        end

        context 'with the date set for post phase' do
          before :each do
            Timecop.freeze(Time.utc(2017, 12, 3, 12, 0, 1))
          end

          it_behaves_like 'the expected hybrid bill stage', '1234', false, 'hybrid_bills/post'
        end


        context 'with the date set for closed phase' do
          before :each do
            Timecop.freeze(Time.utc(2017, 12, 4, 12, 0, 1))
          end

          it 'redirects as expected' do
            expect(get :show, params: { bill_id: '1234' }).to redirect_to(hybrid_bills_path)
          end
        end
      end
    end
  end
end
