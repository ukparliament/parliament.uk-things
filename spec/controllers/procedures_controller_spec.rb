require 'rails_helper'

RSpec.describe ProceduresController, vcr: true do
  describe 'GET show' do
    context 'variable assignment' do
      before(:each) do
        get :show, params: { procedure_id: '5S6p4YsP' }
      end

      it 'should have a response with a http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      context 'assigns @procedure' do
        it 'as a Grom::Node' do
          expect(assigns(:procedure)).to be_a(Grom::Node)
        end

        it 'as a Grom::Node of type Procedure' do
          expect(assigns(:procedure).type).to eq('https://id.parliament.uk/schema/Procedure')
        end

        it 'to the work package with correct id' do
          expect(assigns(:procedure).graph_id).to eq('5S6p4YsP')
        end
      end

      context 'assigns @work_packages' do
        it 'as a Grom::Node' do
          expect(assigns(:work_packages)).to be_a(Array)
        end

        it 'as a Grom::Node of type WorkPackage' do
          expect(assigns(:work_packages).first.type).to eq('https://id.parliament.uk/schema/WorkPackage')
        end
      end
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { procedure_id: '5S6p4YsP' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id?procedure_id=5S6p4YsP"
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
        expect{ get :show, params: { procedure_id: '5S6p4YsP' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
