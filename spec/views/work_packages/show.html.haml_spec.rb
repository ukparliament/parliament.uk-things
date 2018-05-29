require 'rails_helper'

RSpec.describe 'work_packages/show', vcr: true do
  let!(:work_packageable_thing) {
    assign(:work_packageable_thing,
      double(:work_packageable_thing,
        name:'Test work package name',
        weblink: 'www.legislation.gov/test-memorandum',
      )
    )
  }

  let!(:procedure) {
    assign(:procedure,
      double(:procedure,
        name: 'Draft affirmative',
        graph_id: 'tubv779e'
      )
    )
  }

  let!(:business_item){
    assign(:business_item,
      double(:business_item,
        class: 'https://id.parliament.uk/BusinessItem',
        date: DateTime.new(2018,05,30),
        weblink: 'www.test2.com',
        sorted_procedure_steps_by_distance: [
          double(:procedure_step,
            name: 'Procedure step name 2',
            houses: [
              double(:house, name: 'House of Lords'),
              double(:house, name: 'House of Commons')
            ]
          )
        ]
      )
    )
  }

  let!(:laying_business_item) {
    assign(:laying_business_item,
      double(:laying_business_item,
        date: DateTime.new(2018,06,04),
        laying_body: double(:laying_body,
          name: 'Cabinet Office'
        )
      )
    )
  }

  let!(:completed_business_items) {
    assign(:completed_business_items, [])
  }

  let!(:scheduled_business_items) {
    assign(:scheduled_business_items, [])
  }

  let!(:business_items_with_no_date) {
    assign(:business_items_with_no_date, [])
  }

  before(:each) do
    render
  end

  context 'work package details' do
    it 'displays name' do
      expect(rendered).to match(/Test work package name/)
    end
  end

  context 'about' do
    it 'displays procedure name' do
      expect(rendered).to match(/draft affirmative/)
    end

    it 'displays web link' do
      expect(rendered).to match(/<a href="www.legislation.gov\/test-memorandum">/)
    end
  end

  context 'completed steps' do
    context 'when they exist' do
      let!(:completed_business_items) {
        assign(:completed_business_items, [business_item])
      }

      it 'will render heading' do
        expect(response).to match(/Completed stages/)
      end

      it 'will render the work_packages/business_item partial' do
        expect(response).to render_template(partial: 'work_packages/_business_item')
      end
    end

    context 'when they do not exist' do
      it 'will not render the work_packages/business_item partial' do
        expect(response).not_to render_template(partial: 'work_packages/_business_item')
      end
    end
  end

  context 'scheduled steps' do
    context 'when they exist' do
      let!(:scheduled_business_items) {
        assign(:scheduled_business_items, [business_item])
      }

      it 'will render heading' do
        expect(response).to match(/Scheduled upcoming stages/)
      end

      it 'will render the work_packages/business_item partial' do
        expect(response).to render_template(partial: 'work_packages/_business_item')
      end
    end

    context 'when they do not exist' do
      it 'will not render the work_packages/business_item partial' do
        expect(response).not_to render_template(partial: 'work_packages/_business_item')
      end
    end
  end

  context 'steps with no date' do
    context 'when they exist' do
      let!(:business_items_with_no_date) {
        assign(:business_items_with_no_date, [business_item])
      }

      it 'will render heading' do
        expect(response).to match(/Completed stages with no date/)
      end

      it 'will render the work_packages/business_item partial' do
        expect(response).to render_template(partial: 'work_packages/_business_item')
      end
    end

    context 'when they do not exist' do
      it 'will not render the work_packages/business_item partial' do
        expect(response).not_to render_template(partial: 'work_packages/_business_item')
      end
    end
  end
end
