require 'rails_helper'

RSpec.describe 'groups/show', vcr: true do
    before do
      assign(:group, double(:group, name: 'Procedure Committee', graph_id: 'wZVxomZk', date_range: '12 Nov 1974 to present'))
      render
    end

  it 'will render the name of the committee' do
    expect(rendered).to match(/Procedure Committee/)
  end

  it 'will render the date range of the committee' do
    expect(rendered).to match(/12 Nov 1974 to present/)
  end
end
