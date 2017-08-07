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
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
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
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
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
