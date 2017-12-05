require 'rails_helper'

RSpec.describe PeopleController, vcr: true do
  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '3299' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @person' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('https://id.parliament.uk/schema/Person')
    end

    it 'redirects to people/:id' do
      expect(response).to redirect_to(person_path('toes2sa2'))
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { person_id: '1CRqwuTp' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person, @seat_incumbencies, @committee_memberships, @house_incumbencies, @government_incumbencies, @current_party_membership,
    @most_recent_incumbency and @current_incumbency' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('https://id.parliament.uk/schema/Person')

      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('https://id.parliament.uk/schema/SeatIncumbency')
      end

      assigns(:house_incumbencies).each do |house_incumbency|
        expect(house_incumbency).to be_a(Grom::Node)
        expect(house_incumbency.type).to eq('https://id.parliament.uk/schema/HouseIncumbency')
      end

      assigns(:committee_memberships).each do |committee_membership|
        expect(committee_membership).to be_a(Grom::Node)
        expect(committee_membership.type).to eq('https://id.parliament.uk/schema/FormalBodyMembership')
      end

      assigns(:government_incumbencies).each do |government_incumbency|
        expect(government_incumbency).to be_a(Grom::Node)
        expect(government_incumbency.type).to eq('https://id.parliament.uk/schema/GovernmentIncumbency')
      end

      assigns(:opposition_incumbencies).each do |opposition_incumbency|
        expect(opposition_incumbency).to be_a(Grom::Node)
        expect(opposition_incumbency.type).to eq('https://id.parliament.uk/schema/OppositionIncumbency')
      end

      expect(assigns(:current_party_membership)).to be_a(Grom::Node)
      expect(assigns(:current_party_membership).type).to eq('https://id.parliament.uk/schema/PartyMembership')
      expect(assigns(:current_party_membership).current?).to be(true)

      expect(assigns(:most_recent_incumbency)).to be_a(Grom::Node)
      expect(assigns(:most_recent_incumbency).end_date).to be(nil)

      expect(assigns(:current_incumbency)).to be_a(Grom::Node)
      expect(assigns(:current_incumbency).current?).to be(true)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    context 'given a valid postcode' do
      before(:each) do
        get :show, params: { person_id: '1CRqwuTp' }, flash: { postcode: 'E2 0JA' }
      end

      it 'assigns @postcode, @postcode_constituency' do
        expect(assigns(:postcode)).to eq('E2 0JA')

        expect(assigns(:postcode_constituency)).to be_a(Grom::Node)
        expect(assigns(:postcode_constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
      end
    end

    context 'given an invalid postcode' do
      before(:each) do
        get :show, params: { person_id: '1CRqwuTp' }, flash: { postcode: 'apple' }
      end

      it 'assigns @postcode and flash[:error]' do
        expect(assigns(:postcode)).to be(nil)
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end
    end

    context 'with bandiera turned on' do
      before(:each) do
        allow(Pugin::Feature::Bandiera).to receive(:show_committees?).and_return(true)
        allow(Pugin::Feature::Bandiera).to receive(:show_government_roles?).and_return(true)
        get :show, params: { person_id: '1CRqwuTp' }
      end

      it 'adds committee memberships and government roles to history' do
        history = controller.instance_variable_get(:@history)
        count = 0
        history[:years].keys.each { |year| count = count + history[:years][year].length }
        expect(count).to eq(6)
      end
    end

    context 'with bandiera turned off' do
      before(:each) do
        allow(Pugin::Feature::Bandiera).to receive(:show_committees?).and_return(false)
        allow(Pugin::Feature::Bandiera).to receive(:show_government_roles?).and_return(false)
        get :show, params: { person_id: '1CRqwuTp' }
      end

      it 'does not add committee memberships or government roles to history' do
        history = controller.instance_variable_get(:@history)
        count = 0
        history[:years].keys.each { |year| count = count + history[:years][year].length }
        expect(count).to eq(1)
      end
    end
  end


  describe "POST postcode_lookup" do
    before(:each) do
      post :postcode_lookup, params: { person_id: '7KNGxTli', postcode: 'E2 0JA' }
    end

    it 'assigns flash[:postcode]' do
      expect(flash[:postcode]).to eq('E2 0JA')
    end

    it 'redirects to people/:id' do
      expect(response).to redirect_to(person_path('7KNGxTli'))
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
        {
          route: 'show',
          parameters: { person_id: 'toes2sa2' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/person_by_id?person_id=toes2sa2"
        },
        {
          route: 'lookup',
          parameters: { source: 'mnisId', id: '3299' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/person_lookup?property=mnisId&value=3299"
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

  # Test for ApplicationController Parliament::ClientError handling
  describe 'rescue_from Parliament::ClientError' do
    it 'raises an ActionController::RoutingError' do
      expect{ get :show, params: { person_id: '12345678' } }.to raise_error(ActionController::RoutingError)
    end
  end
end
