require 'rails_helper'

RSpec.describe 'collections/_delimited_links' do
  let!(:collections) {
    assign(:collections,
      [
        double(:collection,
          name:     collection_name_text1,
          graph_id: 'xxxxxxx1'
        ),
        double(:collection,
          name:     collection_name_text2,
          graph_id: 'xxxxxxx2'
        ),
      ]
    )
  }

  let!(:collection_name_text1) { 'This is test collection 1.' }
  let!(:collection_name_text2) { 'This is test collection 2.' }

  before(:each) do
    render partial: "collections/delimited_links", locals: { collections: collections }
  end

  context 'collection' do
    context 'converted to HTML' do
      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/xxxxxxx1">This is test collection 1.<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:collection_name_text1) { '<script>This is test collection 1.</script>' }

      it 'sanitized name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/xxxxxxx1">This is test collection 1.<\/a>/)
      end
    end
  end

  context 'listing collections' do
    it 'renders comma separated links to each collection' do
      expect(rendered).to include("<p>\n<a href=\"/collections/xxxxxxx1\">This is test collection 1.</a>\n, \n<a href=\"/collections/xxxxxxx2\">This is test collection 2.</a>\n\n</p>\n")
    end
  end

end
