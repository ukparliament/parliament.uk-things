require 'rails_helper'

RSpec.describe 'shared/article/_aside_block' do
  let!(:subcollection) do
    assign(:subcollection,
      double(:subcollection,
        name:     subcollection_name_text,
        graph_id: 'asdf1234'))
  end

  let!(:article) do
    assign(:article,
      double(:article,
        article_title: article_title_text,
        graph_id:      'xoxoxox8'))
  end

  let!(:collection_article) do
    assign(:article,
      double(:article2,
        article_title: collection_article_title_text,
        graph_id:      'gj7e0ikd'))
  end

  let!(:collection) do
    assign(:collection,
      double(:collection,
        graph_id:       'test1234',
        name:           collection_name_text,
        subcollections: [subcollection],
        articles:       [article, collection_article]))
  end

  let!(:collection_name_text)        { 'This is a test Collection.' }
  let!(:subcollection_name_text)     { 'This is a test subcollection name' }
  let!(:article_title_text)          { 'This is a test Title.' }
  let!(:collection_article_title_text) { 'Another article title' }

  before(:each) do
    render partial: 'shared/article/aside_block', locals: { title: collection.name, collection: collection, graph_id: article.graph_id }
  end

  context 'collection articles' do
    context 'converted to HTML' do
      it 'will render a link to each article in that collection' do
        expect(rendered).to match(/<a href="\/articles\/gj7e0ikd">Another article title<\/a>/)
      end

      it 'will not render a link to the active article in that collection' do
        expect(rendered).to_not match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end

      it 'will use an active class for the list item containing the active article title' do
        expect(rendered).to have_css('li.active .list--details', text: article_title_text)
      end
    end

    context 'sanitize' do
      let!(:collection_article_title_text) { '<script>Another article title</script>' }
      it 'will render the sanitized link to each article in that collection' do
        expect(rendered).to match(/<a href="\/articles\/gj7e0ikd">Another article title<\/a>/)
      end
    end
  end

  context 'collection subcollections' do
    context 'converted to HTML' do
      it 'will render a link to each subcollection in that collection' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:subcollection_name_text) { '<script>Test Subcollection</script>' }
      it 'will render the sanitized link to each subcollection in that collection' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">Test Subcollection<\/a>/)
      end
    end
  end
end
