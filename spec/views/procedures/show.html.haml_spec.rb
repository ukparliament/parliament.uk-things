require 'rails_helper'

RSpec.describe 'procedures/show', vcr: true do
  let!(:procedure) {
    assign(:procedure,
      double(:procedure,
        name: 'Draft affirmative'
      )
    )
  }

  let!(:work_package) {
    assign(:work_package,
      double(:work_package,
        work_packageable_thing_name: 'Work Packageable Thing Test Name',
        graph_id: 'qwerzxcv',
        oldest_business_item_date: DateTime.new(2018,05,04)
      )
    )
  }

  let!(:work_packages) {
    assign(:work_packages, [work_package])
  }
  before(:each) do
    render
  end

  context 'heading' do
    it 'displays procedure name' do
      expect(rendered).to match(/Draft affirmative/)
    end
  end

  context 'work package' do
    it 'displays name of work packageable thing with a link' do
      expect(rendered).to match(/<a href="\/work-packages\/qwerzxcv">Work Packageable Thing Test Name<\/a>/)
    end

    context 'oldest business item date' do
      context 'exists' do
        it 'displays date' do
          expect(rendered).to match(/4 May 2018/)
        end
      end

      context 'does not exist' do
        let!(:work_package) {
          assign(:work_package,
            double(:work_package,
              work_packageable_thing_name: 'Work Packageable Thing Test Name',
              graph_id: 'qwerzxcv',
              oldest_business_item_date: nil,
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
