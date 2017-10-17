require 'rails_helper'

RSpec.describe Parliaments::Houses::PartiesController, vcr: true do
    describe 'GET show' do
      context '@party is nil' do
        # updated VCR cassette in order to set @party to nil
        it 'should raise ActionController::RoutingError' do
          expect{get :show, params: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt', party_id: '891w1b1k' }}.to raise_error(ActionController::RoutingError)
        end
      end

      context '@party is not nil' do
        before(:each) do
          get :show, params: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt', party_id: '891w1b1k' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        context '@parliament' do
          it 'assigns @parliament' do
            expect(assigns(:parliament)).to be_a(Grom::Node)
            expect(assigns(:parliament).type).to eq('https://id.parliament.uk/schema/ParliamentPeriod')
          end
        end

        context '@house' do
          it 'assigns @house' do
            expect(assigns(:house)).to be_a(Grom::Node)
            expect(assigns(:house).type).to eq('https://id.parliament.uk/schema/House')
          end
        end

        context '@party' do
          it 'assigns @party' do
            expect(assigns(:party)).to be_a(Grom::Node)
            expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
          end
        end

        it 'renders the house template' do
          expect(response).to render_template('show')
        end
      end
    end

    describe '#data_check' do
      context 'an available data format is requested' do
        methods = [
          {
            route: 'show',
            parameters: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt', party_id: '891w1b1k' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_house_party?parliament_id=fHx6P1lb&house_id=Kz7ncmrt&party_id=891w1b1k"
          }
        ]

        before(:each) do
          headers = { 'Accept' => 'application/rdf+xml' }
          request.headers.merge(headers)
        end

        it 'should have a response with http status redirect (302)' do
          methods.each do |method|
            if method.include?(:parameters)
              get method[:route].to_sym, params: method[:parameters]
            else
              get method[:route].to_sym
            end
            expect(response).to have_http_status(302)
          end
        end

        it 'redirects to the data service' do
          methods.each do |method|
            if method.include?(:parameters)
              get method[:route].to_sym, params: method[:parameters]
            else
              get method[:route].to_sym
            end
            expect(response).to redirect_to(method[:data_url])
          end
        end
      end
    end
end
