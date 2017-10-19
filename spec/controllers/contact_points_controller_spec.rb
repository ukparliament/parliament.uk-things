require 'rails_helper'

RSpec.describe ContactPointsController, vcr: true do
  describe 'GET show' do
    it 'should have a response with a http status ok (200)' do
      get :show, params: { contact_point_id: 't3Qeaou5' }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @contact_point' do
      get :show, params: { contact_point_id: 't3Qeaou5' }
      expect(assigns(:contact_point)).to be_a(Grom::Node)
      expect(assigns(:contact_point).type).to eq('https://id.parliament.uk/schema/ContactPoint')
    end

    describe 'download' do
      card = "BEGIN:VCARD\nVERSION:3.0\nTEL;TYPE=fax:faxNumber - 1\nN:personFamilyName - 1;personGivenName - 1;;;\nFN:personGivenName - 1 personFamilyName - 1\nEND:VCARD\n"
      file_options = { filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false } }

      before do
        expect(controller).to receive(:send_data).with(card, file_options) { controller.head :ok }
      end

      it 'should download a vcard attachment' do
        get :show, params: { contact_point_id: 't3Qeaou5' }
      end
    end

    describe '#data_check' do
      context 'an available data format is requested' do
        methods = [
            {
              route: 'show',
              parameters: { contact_point_id: 'fFm9NQmr' },
              data_url: "#{ENV['PARLIAMENT_BASE_URL']}/contact_point_by_id?contact_point_id=fFm9NQmr"
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
end
