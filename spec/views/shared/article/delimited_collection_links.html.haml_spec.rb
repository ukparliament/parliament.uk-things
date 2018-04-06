require 'rails_helper'

RSpec.describe 'shared/article/_delimite_collection_links' do
  let!(:collections) do
    assign(:links,
      [
        double(:collection,
          name:     collection_link_name_text1,
          graph_id: 'xxxxxxx1'),
        double(:collection,
          name:     collection_link_name_text2,
          graph_id: 'xxxxxxx2')
      ])
  end

  let!(:collection_link_name_text1) { 'This is test collection 1.' }
  let!(:collection_link_name_text2) { 'This is test collection 2.' }

  before(:each) do
    render partial: 'shared/article/delimited_collection_links', locals: { links: collections }
  end

  context 'collection' do
    context 'converted to HTML' do
      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/xxxxxxx1">This is test collection 1.<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:collection_link_name_text1) { '<script>This is test collection 1.</script>' }

      it 'sanitized name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/xxxxxxx1">This is test collection 1.<\/a>/)
      end
    end
  end

  context 'listing collections' do
    it 'renders comma separated links to each collection' do
      expect(rendered).to include("<a href=\"/collections/xxxxxxx1\">This is test collection 1.</a>\n, \n<a href=\"/collections/xxxxxxx2\">This is test collection 2.</a>")
    end
  end
end
