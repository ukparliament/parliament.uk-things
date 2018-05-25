require 'rails_helper'

RSpec.describe 'procedures/show', vcr: true do
  let!(:procedure) {
    assign(:procedure,
      double(:procedure,
        name: 'Draft affirmative'
      )
    )
  }

  let!(:work_packageable_thing) {
    assign(:work_packageable_thing,
      double(:work_packageable_thing,
        name: 'Work Packageable Thing Test Name',
        graph_id: 'asdf1234',
        oldest_business_item_date: DateTime.new(2018,05,04)
      )
    )
  }

  let!(:work_packageable_things) {
    assign(:work_packageable_things, [work_packageable_thing])
  }

  before(:each) do
    render
  end

  context 'heading' do
    it 'displays procedure name' do
      expect(rendered).to match(/Draft affirmative/)
    end
  end

  context 'work packageable things' do
    it 'displays name with a link' do
      expect(rendered).to match(/<a href="\/work-packages\/asdf1234">Work Packageable Thing Test Name<\/a>/)
    end

    context 'oldest business item date' do
      context 'exists' do
        it 'displays date' do
          expect(rendered).to match(/4 May 2018/)
        end
      end

      context 'does not exist' do
        let!(:work_packageable_thing) {
          assign(:work_packageable_thing,
            double(:work_packageable_thing,
              name: 'Work Packageable Thing Test Name',
              graph_id: 'asdf1234',
              oldest_business_item_date: nil
            )
          )
        }

        it 'does not display date' do
          expect(rendered).not_to match(/4 May 2018/)
        end
      end
    end
  end
end
