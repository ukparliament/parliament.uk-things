require 'rails_helper'

RSpec.describe PlacesController, vcr: true do

  describe 'GET show' do
    before(:each) do
      get :show, params: { place_id: 'E15000001' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @place, @constituencies' do
      expect(assigns(:place)).to be_a(Grom::Node)
      expect(assigns(:place).type).to eq('http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion')

      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
      end
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
          parameters: { place_id: 'E15000001' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/region_by_id?region_code=E15000001"
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
