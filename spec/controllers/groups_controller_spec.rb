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
      expect(assigns(:group).type).to include('https://id.parliament.uk/schema/Group')
      expect(assigns(:group).type).to include('https://id.parliament.uk/schema/FormalBody')
      expect(assigns(:group).member_count).to eq(13)
    end

    it 'assigns @contact_points' do
      expect(assigns(:contact_points).first).to be_a(Grom::Node)
      expect(assigns(:contact_points).first.type).to eq('https://id.parliament.uk/schema/ContactPoint')
    end

    it 'assigns @postal_address' do
      expect(assigns(:postal_address)).to be_a(Grom::Node)
      expect(assigns(:postal_address).type).to eq('https://id.parliament.uk/schema/PostalAddress')

      expected_full_address = 'addressLine1 - 1, addressLine2 - 1, postCode - 1'
      expect(assigns(:postal_address).full_address).to eq(expected_full_address)
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
