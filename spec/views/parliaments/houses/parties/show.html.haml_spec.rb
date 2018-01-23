require 'rails_helper'

RSpec.describe 'parliaments/houses/parties/show', vcr: true do
  before do
    assign(:parliament, double(:parliament, date_range: '2005 to 2010', graph_id: 'Kz7ncmrt'))
    assign(:party, double(:party, name: 'Conservative', graph_id: 'DIifZMjq'))
    assign(:house, double(:house, name: 'House of Lords', graph_id: 'WkUWUBMx'))
    render
  end

  context 'header' do
    it 'will render the party name' do
      expect(rendered).to match(/Conservative/)
    end

    it 'will render the parliament date range' do
      expect(rendered).to match(/2005 to 2010 parliament/)
    end
  end

  context 'links' do
    it 'will link to MPs and Lords for that party' do
      expect(rendered).to have_link('MPs and Lords', href: parliament_house_party_members_path('Kz7ncmrt', 'WkUWUBMx', 'DIifZMjq'))
    end
  end
end
