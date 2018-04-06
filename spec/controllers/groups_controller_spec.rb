require 'rails_helper'

RSpec.describe GroupsController, vcr: true do
  describe 'GET show' do
    before(:each) do
      get :show, params: { group_id: 'P7Ne09WK' }
    end

    it 'response have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @group' do
      expect(assigns(:group)).to be_a(Grom::Node)
      expect(assigns(:group).type).to include('https://id.parliament.uk/schema/Group')
      expect(assigns(:group).type).to include('https://id.parliament.uk/schema/FormalBody')
      expect(assigns(:group).member_count).to eq(12)
    end

    it 'assigns @house' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('https://id.parliament.uk/schema/House')
      expect(assigns(:house).name).to eq('houseName - 1')
    end

    it 'assigns @person' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('https://id.parliament.uk/schema/Person')
      expect(assigns(:person).display_name).to eq('F31CBD81AD8343898B49DC65743F0BDF - 1')
      expect(assigns(:person).image_id).to eq('ZY0Mx1bp')
    end

    it 'assigns @formal_body_type' do
      expect(assigns(:formal_body_type)).to be_a(Grom::Node)
      expect(assigns(:formal_body_type).type).to eq('https://id.parliament.uk/schema/FormalBodyType')
      expect(assigns(:formal_body_type).name).to eq('formalbodyTypeName - 1')
    end

    it 'assigns @party' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
      expect(assigns(:party).name).to eq('partyName - 1')
    end

    it 'assigns @constituency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
      expect(assigns(:constituency).name).to eq('constituencyGroupName - 1')
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
          parameters: { group_id: 'P7Ne09WK' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id?group_id=P7Ne09WK"
        }
      ]
    end

    it_behaves_like 'a data service request'
  end
end
