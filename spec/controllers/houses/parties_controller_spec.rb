require 'rails_helper'

RSpec.describe Houses::PartiesController, vcr: true do
  describe "GET show" do
    context 'both house and party have a valid id' do
      before(:each) do
        get :show, params: { house_id: 'Kz7ncmrt', party_id: '891w1b1k' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @house and @party' do
        expect(assigns(:house)).to be_a(Grom::Node)
        expect(assigns(:house).type).to eq('https://id.parliament.uk/schema/House')
        expect(assigns(:party)).to be_a(Grom::Node)
        expect(assigns(:party).type).to eq('https://id.parliament.uk/schema/Party')
      end

      it 'renders the party template' do
        expect(response).to render_template('show')
      end
    end

    context 'party id is invalid' do
      it 'raises an error if @party is nil' do
        house_id = 'Kz7ncmrt'
        party_id = 'zzzzzzzz'

        expect{ get :show, params: { house_id: house_id, party_id: party_id } }.to raise_error(ActionController::RoutingError, 'Invalid party ID')
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
        {
          route: 'show',
          parameters: { house_id: 'Kz7ncmrt', party_id: '891w1b1k' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/house_party_by_id?house_id=Kz7ncmrt&party_id=891w1b1k"
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
