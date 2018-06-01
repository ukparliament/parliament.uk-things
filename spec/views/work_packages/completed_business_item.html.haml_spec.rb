require 'rails_helper'

RSpec.describe 'work_packages/_completed_business_item', vcr: true do
  let!(:grouped_business_item){
    assign(:grouped_business_item,
      double(:grouped_business_item,
        class: BusinessItemGroupingHelper::BusinessItemGroupedObject,
        date: DateTime.new(2018,04,05),
        nodes: [
          double(:grouped_business_item_node,
            weblink: 'www.test.com',
            sorted_procedure_steps_by_distance: [
              double(:procedure_step,
                name: 'Procedure step name 1',
                houses: [ double(:house, name: 'House of Commons')]
              )
            ]
          ),
          double(:grouped_business_item_node,
            date: nil,
            weblink: '',
            sorted_procedure_steps_by_distance: [
              double(:procedure_step,
                name: 'Procedure step name 2',
                houses: [ double(:house, name: 'House of Commons') ]
              )
            ]
          )
        ]
      )
    )
  }

  let!(:ungrouped_business_item){
    assign(:ungrouped_business_item,
      double(:ungrouped_business_item,
        class: 'https://id.parliament.uk/BusinessItem',
        date: DateTime.new(2018,05,30),
        weblink: 'www.test3.com',
        sorted_procedure_steps_by_distance: [
          double(:procedure_step,
            name: 'Procedure step name 3',
            houses: [
              double(:house, name: 'House of Commons'),
              double(:house, name: 'House of Lords')
            ]
          )
        ]
      )
    )
  }

  context 'completed business items' do
    context 'when they are grouped' do
      before(:each) do
        render partial: 'work_packages/completed_business_item', locals: { business_item: grouped_business_item }
      end

      it 'displays date' do
        expect(rendered).to match(/5 April 2018/)
      end

      it 'displays house name' do
        expect(rendered).to match(/House of Commons/)
      end

      it 'displays procedure step name' do
        expect(rendered).to match(/Procedure step name 1/)
        expect(rendered).to match(/Procedure step name 2/)
      end

      it 'displays web link' do
        expect(rendered).to match(/www.test.com/)
      end
    end

    context 'when they are not grouped' do
      before(:each) do
        render partial: 'work_packages/completed_business_item', locals: { business_item: ungrouped_business_item }
      end

      it 'displays laying date' do
        expect(rendered).to match(/30 May 2018/)
      end

      it 'displays house name' do
        expect(rendered).to match(/House of Lords/)
        expect(rendered).to match(/House of Commons/)
      end

      it 'displays Parliamentary procedure step name' do
        expect(rendered).to match(/Procedure step name 3/)
      end

      it 'displays web link' do
        expect(rendered).to match(/www.test3.com/)
      end
    end
  end
end
