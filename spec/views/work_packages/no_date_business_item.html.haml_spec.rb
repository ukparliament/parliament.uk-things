require 'rails_helper'

RSpec.describe 'work_packages/_no_date_business_item', vcr: true do
  let!(:no_date_business_item){
    assign(:no_date_business_item,
      double(:no_date_business_item,
        weblink: 'www.test6.com',
        sorted_procedure_steps_by_distance: [
          double(:procedure_step,
            name: 'Procedure step name 6',
            houses: [
              double(:house, name: 'House of Lords')
            ]
          )
        ]
      )
    )
  }

  context 'no date business items' do
    before(:each) do
      render partial: 'work_packages/no_date_business_item', locals: { business_item: no_date_business_item }
    end
    it 'displays house name' do
      expect(rendered).to match(/House of Lords/)
    end

    it 'displays Parliamentary procedure step name' do
      expect(rendered).to match(/Procedure step name 6/)
    end

    it 'displays web link' do
      expect(rendered).to match(/www.test6.com/)
    end
  end
end
