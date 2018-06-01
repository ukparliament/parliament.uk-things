require 'rails_helper'

RSpec.describe 'work_packages/_scheduled_business_item', vcr: true do
  let!(:scheduled_business_item){
    assign(:scheduled_business_item,
      double(:scheduled_business_item,
        date: DateTime.new(2018,06,23),
        weblink: 'www.test5.com',
        sorted_procedure_steps_by_distance: [
          double(:procedure_step,
            name: 'Procedure step name 5',
            houses: [
              double(:house, name: 'House of Commons')
            ]
          )
        ]
      )
    )
  }

  context 'scheduled business items' do
    before(:each) do
      render partial: 'work_packages/scheduled_business_item', locals: { business_item: scheduled_business_item }
    end

    it 'displays laying date' do
      expect(rendered).to match(/23 June 2018/)
    end

    it 'displays house name' do
      expect(rendered).to match(/House of Commons/)
    end

    it 'displays Parliamentary procedure step name' do
      expect(rendered).to match(/Procedure step name 5/)
    end

    it 'displays web link' do
      expect(rendered).to match(/www.test5.com/)
    end
  end
end
