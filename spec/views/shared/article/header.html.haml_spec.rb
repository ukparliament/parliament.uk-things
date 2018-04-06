require 'rails_helper'

RSpec.describe 'shared/article/_header' do
  let!(:article) do
    assign(:article,
      double(:article,
        title:           article_title_text,
        article_summary: '## This is a test summary.',
        article_body:    article_body_text,
        graph_id:        article_graph_id))
  end

  let!(:subcollection) do
    assign(:subcollection,
      double(:subcollection,
        name:     subcollection_name_text,
        graph_id: 'asdf1234'))
  end

  let!(:collections) do
    assign(:collections,
      [
        double(:collections,
          name:           collection_name_text,
          description:    '**This** is a test description of a Collection.',
          graph_id:       'h93dvh57',
          subcollections: [subcollection],
          articles:       [
            double(:article,
              article_title: article_title_text,
              graph_id:      article_graph_id),
            double(:article2,
              article_title: collection_article_title_text,
              graph_id:      'gj7e0ikd')
          ])
      ])
  end

  let!(:article_graph_id)              { 'a3d21x98' }
  let!(:article_title_text)            { 'This is a test Title.' }
  let!(:article_body_text)             { '__This__ is an article body' }
  let!(:collection_name_text)          { 'This is a test Collection.' }
  let!(:collection_article_title_text) { 'Another article title' }
  let!(:subcollection_name_text)       { 'Test Subcollection' }
  let!(:parent_collection_name_text)   { 'Test Parent Collection' }

  before(:each) do
    render partial: 'shared/article/header', locals: { title: article.title, summary: article.article_summary, collections: collections }
  end

  context 'converted to HTML' do
    it 'will render the title correctly' do
      expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
    end

    it 'will render the summary correctly' do
      expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
    end
  end

  context 'sanitize' do
    let!(:article_title_text) { '<script>This is a test Title.</script>' }
    let!(:article_body_text)  { '<script>__This__ is an article body</script>' }

    it 'will render the sanitized article title correctly' do
      expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
    end

    it 'will render the sanitized article summary correctly' do
      expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
    end
  end

  context 'when collections exist' do
    it "will render 'in' text" do
      expect(rendered).to match(/In/)
    end

    it 'will render the shared/article/delimited_collection_links partial' do
      expect(rendered).to render_template(partial: 'shared/article/_delimited_collection_links')
    end
  end

  context 'when collections do not exist' do
    let!(:collections) do
      assign(:collections, [])
    end
    it "will not render 'in' text" do
      expect(rendered).not_to match(/In/)
    end

    it 'will not render the shared/article/delimited_collection_links partial' do
      expect(rendered).to_not render_template(partial: 'shared/article/_delimited_collection_links')
    end
  end
end
