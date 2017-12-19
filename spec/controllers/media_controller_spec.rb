require 'rails_helper'

RSpec.describe MediaController, vcr: true do
  describe "GET show" do
    before(:each) do
      get :show, params: { medium_id: 'qnsCGpnw' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @image' do
      expect(assigns(:image)).to be_a(Grom::Node)
      expect(assigns(:image).type).to eq('https://id.parliament.uk/schema/MemberImage')
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
          parameters: { medium_id: 'qnsCGpnw' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/image_by_id?image_id=qnsCGpnw"
        }
      ]
    end

    it_behaves_like 'a data service request'
  end
end
