require 'rails_helper'

RSpec.describe ConstituenciesController, vcr: true do
  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'onsCode', id: 'E14000699' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @constituency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
    end

    it 'redirects to constituencies/:id' do
      expect(response).to redirect_to(constituency_path('6ptkUjxb'))
    end
  end

  describe 'GET show' do
    context 'variable assignment' do
      before(:each) do
        get :show, params: { constituency_id: 't7YWWdzQ' }
      end

      it 'should have a response with a http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @constituency, @seat_incumbencies, @current_incumbency, @party and regions' do
        expect(assigns(:constituency)).to be_a(Grom::Node)
        expect(assigns(:constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')

        assigns(:seat_incumbencies).each do |seat_incumbency|
          expect(seat_incumbency).to be_a(Grom::Node)
          expect(seat_incumbency.type).to eq('https://id.parliament.uk/schema/SeatIncumbency')
        end

        expect(assigns(:current_incumbency)).to be_a(Grom::Node)
        expect(assigns(:current_incumbency).type).to eq('https://id.parliament.uk/schema/SeatIncumbency')
        expect(assigns(:current_incumbency).current?).to be(true)

        expect(assigns(:party)).to be_a(Grom::Node)
        expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
      end

      it 'assigns @seat_incumbencies in reverse chronological order' do
        expect(assigns(:seat_incumbencies)[0].start_date).to eq(DateTime.new(2015, 5, 7))
        expect(assigns(:seat_incumbencies)[1].start_date).to eq(DateTime.new(2010, 5, 6))
      end

      it 'assigns @current_incumbency to be the current incumbency' do
        expect(assigns(:current_incumbency).start_date).to eq(DateTime.new(2017, 6, 8))
      end

      it 'assigns @party' do
        expect(assigns(:party)).to be_a(Grom::Node)
        expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
      end

      it 'assigns regions when available' do
        expect(assigns(:constituency).regions).to be_a(Array)
        assigns(:constituency).regions.each do |region|
          expect(region).to be_a(Grom::Node)
          expect(region.type).to eq('http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion')
        end
      end

      it 'assigns regions to an empty array if no regions are available' do
        expect(assigns(:constituency).regions).to be_a(Array)
        expect(assigns(:constituency).regions.empty?).to be true
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'given a valid postcode' do
      before(:each) do
        get :show, params: { constituency_id: 'xeQCZvTU' }, flash: { postcode: 'E2 0JA' }
      end

      it 'assigns @postcode, @postcode_constituency' do
        expect(assigns(:postcode)).to eq('E2 0JA')

        expect(assigns(:postcode_constituency)).to be_a(Grom::Node)
        expect(assigns(:postcode_constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
      end
    end

    context 'given an invalid postcode' do
      before(:each) do
        get :show, params: { constituency_id: 't7YWWdzQ' }, flash: { postcode: 'apple' }
      end

      it 'assigns @postcode and flash[:error]' do
        expect(assigns(:postcode)).to be(nil)
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end
    end
  end

  describe "POST postcode_lookup" do
    before(:each) do
      post :postcode_lookup, params: { constituency_id: 'xeQCZvTU', postcode: 'E2 0JA' }
    end

    it 'assigns flash[:postcode]' do
      expect(flash[:postcode]).to eq('E2 0JA')
    end

    it 'redirects to constituency/:id' do
      expect(response).to redirect_to(constituency_path('xeQCZvTU'))
    end
  end

  describe 'GET map' do
    before(:each) do
      get :map, params: { constituency_id: 'dwtSdieB' }
    end

    it 'should have a response with a http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
    end

    it 'renders the map template' do
      expect(response).to render_template('map')
    end

    context 'request JSON' do
      before(:each) do
        headers = { 'Accept' => 'application/json' }
        request.headers.merge(headers)
      end

      it 'should have a response with a http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @constituency' do
        expect(assigns(:constituency)).to be_a(Grom::Node)
        expect(assigns(:constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
      end

      it 'renders the map template' do
        expect(response).to render_template('map')
      end

      context 'constituency is not current' do
        it 'will respond with ActionController::RoutingError' do
          expect{ get :map, params: { constituency_id: 'dwtSdieB' } }.to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      METHODS = [
        {
          route: 'lookup',
          parameters: { source: 'mnisId', id: '3274' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_lookup?property=mnisId&value=3274"
        },
        {
          route: 'show',
          parameters: { constituency_id: 'vUPobpVT' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituency_by_id?constituency_id=vUPobpVT"
        }
      ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end

    end

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end

      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :show, params: { constituency_id: 'xeQCZvTU' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end

end
