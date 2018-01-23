require 'rails_helper'

RSpec.describe 'parliaments/parties/show', vcr: true do
  before do
    assign(:parliament, double(:parliament, date_range: '2005 to 2010', graph_id: 'Kz7ncmrt'))
    assign(:party, double(:party, name: 'Conservative', graph_id: 'DIifZMjq'))
    render
  end

  context 'header' do
    it 'will render the party name' do
      expect(rendered).to match(/Conservative/)
    end

    it 'will render the parliament date range' do
      expect(rendered).to match(/2005 to 2010 Parliament/)
    end
  end

  context 'links' do
    it 'will link to MPs and Lords for that party' do
      expect(rendered).to have_link('MPs and Lords', href: parliament_party_members_path('Kz7ncmrt', 'DIifZMjq'))
    end
  end
end
