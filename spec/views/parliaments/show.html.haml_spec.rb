require 'rails_helper'

RSpec.describe 'parliaments/show', vcr: true do
  before do
    assign(:parliament, double(:parliament, date_range: '2005 to 2010', graph_id: 'Kz7ncmrt'))
    render
  end

  context 'header' do
    it 'will render the parliament date range' do
      expect(rendered).to match(/2005 to 2010 Parliament/)
    end

    it 'will render a link to view all parliaments' do
      expect(rendered).to have_link('View all parliaments', href: parliaments_path)
    end
  end

  context 'links' do
    it 'will link to MPs and Lords' do
      expect(rendered).to have_link('MPs and Lords', href: parliament_members_path('Kz7ncmrt'))
    end

    it 'will link to Parties' do
      expect(rendered).to have_link('Parties', href: parliament_parties_path('Kz7ncmrt'))
    end

    it 'will link to Constituencies' do
      expect(rendered).to have_link('Constituencies', href: parliament_constituencies_path('Kz7ncmrt'))
    end
  end
end
