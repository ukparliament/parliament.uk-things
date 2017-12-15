require 'rails_helper'

RSpec.describe Parliaments::HousesController, vcr: true do
  describe 'GET show' do
    context '@house is nil' do
      # updated VCR cassette in order to set @house to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :show, params: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt' }}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@house is not nil' do
      before(:each) do
        get :show, params: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt' }
      end

      context '@parliament' do
        it 'assigns @parliament' do
          expect(assigns(:parliament)).to be_a(Grom::Node)
          expect(assigns(:parliament).type).to eq('https://id.parliament.uk/schema/ParliamentPeriod')
        end
      end

      context '@house' do
        it 'assigns @house' do
          expect(assigns(:house)).to be_a(Grom::Node)
          expect(assigns(:house).type).to eq('https://id.parliament.uk/schema/House')
        end
      end

      it 'renders the house template' do
        expect(response).to render_template('show')
      end
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { parliament_id: 'fHx6P1lb', house_id: 'Kz7ncmrt' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_house?parliament_id=fHx6P1lb&house_id=Kz7ncmrt"
        }
      ]
    end

    it_behaves_like 'a data service request'
  end
end
