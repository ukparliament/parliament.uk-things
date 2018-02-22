require 'rails_helper'

RSpec.describe 'collections/show', vcr: true do
  let!(:subcollection) {
    assign(:subcollection,
      double(:subcollection,
        name:        subcollection_name_text,
        graph_id:    'asdf1234'
      )
    )
  }
  let!(:article) {
    assign(:article,
      double(:article,
        article_title:   article_title_text,
        graph_id:        'xoxoxox8'
      )
    )
  }

  let!(:collection) {
    assign(:collection,
      double(:collection,
        name:           collection_name_text,
        description:    collection_description_text,
        subcollections: [subcollection],
        articles:       [article]
      )
    )
  }

  before(:each) do
    render
  end


  context 'valid data' do
    let!(:collection_name_text) { 'This is a test Collection.' }
    let!(:collection_description_text) { '**This** is a test description of a Collection.' }
    let!(:subcollection_name_text) { 'This is a test subcollection name' }
    let!(:article_title_text) { 'This is a test Title.' }

    context 'headings' do
      it 'displays the correct header' do
        expect(rendered).to match(/In this section/)
      end
    end

    context 'collection' do
      it 'name will render correctly' do
        expect(rendered).to match(/<h1>This is a test Collection.<\/h1>/)
      end

      it 'description will render correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is a test description of a Collection.<\/p>/)
      end
    end

    context 'subcollection' do
      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name<\/a>/)
      end
    end

    context 'articles' do
      it 'will render articles' do
        expect(rendered).to match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end
    end
  end

  context 'sanitize' do
    let!(:collection_name_text) { '<script>This is a test Collection name.</script>' }
    let!(:collection_description_text) { '<script>__This__ is a Collection descrpition</script>' }
    let!(:subcollection_name_text) { '<script>This is a test subcollection name.</script>' }
    let!(:article_title_text) { '<script>This is a test Title.</script>' }

    context 'collection' do
      it 'name will render correctly' do
        expect(rendered).to match(/<h1>This is a test Collection name.<\/h1>/)
      end

      it 'description will render correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is a Collection descrpition<\/p>/)
      end
    end

    context 'subcollection' do
      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name.<\/a>/)
      end
    end

    context 'articles' do
      it 'will render articles' do
        expect(rendered).to match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end
    end
  end
end
