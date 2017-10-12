require 'rails_helper'
#require 'net/http'
require 'pry'
require 'pry-nav'


RSpec.describe HybridBillsController do

	before(:each) do
		WebMock.allow_net_connect!
        VCR.turn_off!
    end

	context 'hybrid bill index page' do
			describe 'GET index' do
			    before(:each) do
			      get :index
			    end

			    it 'should have a response with http status ok (200)' do
			      expect(response).to have_http_status(:ok)
			    end

			    it 'renders the index template' do
			      expect(response).to render_template('index')
			    end
		    end
	end

	context 'hybrid bill show page' do

			describe 'GET show' do
			    before(:each) do
			      get :show, params: { petition: 1 }
			    end

			    it 'should have a response with http status ok (200)' do
			      expect(response).to have_http_status(:ok)
			    end

			    it 'renders the show template' do
			      expect(response).to render_template('show')
          end

        context 'with a stage' do
          context 'submission-type' do
            context 'with the required data' do
              it 'responds with a 200 status' do
                expect(response).to have_http_status(:ok)
              end

              it 'loads the expected template' do
                expect(response).to render_template('hybrid_bills/steps/1')
              end
            end

            context 'without the required data' do
              it 'redirects the user to the show page' do
                expect(response).to redirect_to hybrid_bills_path
              end
            end
          end
        end
      end
	end

	context "hybrid bill test page" do
			describe '#test' do

				it 'should match the data ' do
					data = {
 					 "userId": 1,
  					"id": 1,
 					 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 					 "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
					}

                data = double
	                allow(data).to receive(:test).and_return({
 					 "userId": 1,
  					"id": 1,
 					 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 					 "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
					})
			    end
		    end
	end
end
