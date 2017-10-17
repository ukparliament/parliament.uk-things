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
    context 'an available data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
        get :show, params: { medium_id: 'qnsCGpnw' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to the data service' do
        expect(response).to redirect_to("#{ENV['PARLIAMENT_BASE_URL']}/image_by_id?image_id=qnsCGpnw")
      end
    end
  end
end
