require 'rails_helper'

RSpec.describe ConceptsController, vcr: true do
  describe 'GET show' do
    context 'variable assignment' do
      context 'when successful' do
        before(:each) do
          get :show, params: { concept_id: 'yDYJSViV' }
        end
        it 'should have a response with a http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns @concept as a Grom::Node' do
          expect(assigns(:concept)).to be_a(Grom::Node)
        end

        it 'assigns @concept as a Grom::Node of type Article' do
          expect(assigns(:concept).type).to eq('https://id.parliament.uk/schema/Concept')
        end

        it 'assigns @concept to the article with correct id' do
          expect(assigns(:concept).graph_id).to eq('yDYJSViV')
        end
      end

      context 'when unsuccessful' do
        it 'should raise ActionController::RoutingError error' do
          expect { get :show, params: { concept_id: 'asdf1234' } }.to raise_error(ActionController::RoutingError, 'Concept Not Found')
        end
      end
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { concept_id: 'yDYJSViV' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/concept_by_id?concept_id=yDYJSViV"
        }
      ]
    end

    it_behaves_like 'a data service request'

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end
      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :show, params: { concept_id: 'yDYJSViV' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
