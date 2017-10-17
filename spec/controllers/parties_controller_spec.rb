require 'rails_helper'

RSpec.describe PartiesController, vcr: true do
  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '231' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @party' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
    end

    it 'redirects to parties/:id' do
      expect(response).to redirect_to(party_path('UrTPD0AS'))
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { party_id: '891w1b1k' }
    end

    it 'response have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @party' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
        {
          route: 'show',
          parameters: { party_id: '891w1b1k' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/party_by_id?party_id=891w1b1k"
        },
        {
          route: 'lookup',
          parameters: { source: 'mnisId', id: '96' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/party_lookup?property=mnisId&value=96"
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
