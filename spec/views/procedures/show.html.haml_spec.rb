require 'rails_helper'

RSpec.describe 'procedures/show', vcr: true do
  let!(:procedure) {
    assign(:procedure,
      double(:procedure,
        name: 'Draft affirmative',
        graph_id: 12345678
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

  context 'work packages' do
    it 'displays a link to work packages' do
      expect(rendered).to match(/<a href="\/procedures\/12345678\/work-packages">Procedural activity<\/a>/)
    end
  end
end
