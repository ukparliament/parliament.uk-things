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
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { place_id: 'E15000001' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/region_by_id?region_code=E15000001"
        }
      ]
    end

    it_behaves_like 'a data service request'
  end
end
