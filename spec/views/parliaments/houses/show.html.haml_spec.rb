require 'rails_helper'

RSpec.describe 'parliaments/houses/show', vcr: true do
  before do
    assign(:parliament, double(:parliament, date_range: '2005 to 2010', graph_id: 'Kz7ncmrt'))
    assign(:house, double(:house, name: 'House of Lords', graph_id: 'WkUWUBMx'))
    render
  end

  context 'header' do
    it 'will render the house name' do
      expect(rendered).to match(/House of Lords/)
    end

    it 'will render the parliament date range' do
      expect(rendered).to match(/2005 to 2010 parliament/)
    end
  end

  context 'links' do
    it 'will link to MPs and Lords' do
      expect(rendered).to have_link('MPs and Lords', href: parliament_house_members_path('Kz7ncmrt', 'WkUWUBMx'))
    end

    it 'will link to parties' do
      expect(rendered).to have_link('Parties', href: parliament_house_parties_path('Kz7ncmrt', 'WkUWUBMx'))
    end
  end
end
