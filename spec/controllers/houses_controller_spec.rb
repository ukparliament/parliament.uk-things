require 'rails_helper'

RSpec.describe HousesController, vcr: true do
  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'name', id: 'House of Lords' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @house' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('https://id.parliament.uk/schema/House')
    end

    it 'redirects to houses/:id' do
      expect(response).to redirect_to(house_path('MvLURLV5'))
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { house_id: 'Kz7ncmrt' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('https://id.parliament.uk/schema/House')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'lookup',
          parameters: { source: 'name', id: 'House of Lords' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/house_lookup?property=name&value=House+of+Lords"
        },
        {
          route: 'show',
          parameters: { house_id: 'Kz7ncmrt' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id?house_id=Kz7ncmrt"
        }
      ]
    end

    it_behaves_like 'a data service request'
  end
end
