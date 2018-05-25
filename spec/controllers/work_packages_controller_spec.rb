require 'rails_helper'

RSpec.describe WorkPackagesController, vcr: true do
  describe 'GET show' do
    context 'variable assignment' do
      before(:each) do
        get :show, params: { work_package_id: 'F7f4F0bp' }
      end

      it 'should have a response with a http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      context 'assigns @work_package' do
        it 'as a Grom::Node' do
          expect(assigns(:work_package)).to be_a(Grom::Node)
        end

        it 'as a Grom::Node of type WorkPackage' do
          expect(assigns(:work_package).type).to eq('https://id.parliament.uk/schema/WorkPackage')
        end

        it 'to the work package with correct id' do
          expect(assigns(:work_package).graph_id).to eq('F7f4F0bp')
        end
      end

      context 'assigns @work_packageable_thing' do
        it 'as a Grom::Node' do
          expect(assigns(:work_packageable_thing)).to be_a(Grom::Node)
        end

        it 'as a Grom::Node of type WorkPackageableThing' do
          expect(assigns(:work_packageable_thing).type).to include('https://id.parliament.uk/schema/WorkPackageableThing')
        end
      end

      context 'assigns @procedure' do
        it 'as a Grom::Node' do
          expect(assigns(:procedure)).to be_a(Grom::Node)
        end

        it 'as a Grom::Node of type Procedure' do
          expect(assigns(:procedure).type).to eq('https://id.parliament.uk/schema/Procedure')
        end
      end

      context 'assigns @business_items' do
        it 'to be an array of Grom::Nodes' do
          expect(assigns(:business_items).first).to be_a(Grom::Node)
        end

        it 'to be an array of Grom::Nodes of type BusinessItem' do
          expect(assigns(:business_items).first.type).to include('https://id.parliament.uk/schema/BusinessItem')
        end
      end
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { work_package_id: 'f6HEdGTF' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/work_package_by_id?work_package_id=f6HEdGTF"
        }
      ]
    end

    it_behaves_like 'a data service request'

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end
      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :show, params: { work_package_id: 'f6HEdGTF' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
