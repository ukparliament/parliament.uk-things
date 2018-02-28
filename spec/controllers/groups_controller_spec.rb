require 'rails_helper'

RSpec.describe GroupsController, vcr: true do
  describe 'GET show' do
    before(:each) do
      get :show, params: { group_id: 'ziLwaBLc' }
    end

    it 'response have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @group' do
      expect(assigns(:group)).to be_a(Grom::Node)
      expect(assigns(:group).type).to eq('https://id.parliament.uk/schema/Group')
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
          parameters: { group_id: 'ziLwaBLc' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id?group_id=ziLwaBLc"
        }
      ]
    end

    it_behaves_like 'a data service request'
  end
end
