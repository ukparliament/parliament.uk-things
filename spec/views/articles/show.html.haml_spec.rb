require 'rails_helper'

RSpec.describe 'articles/show', vcr: true do
  let!(:article) {
    assign(:article,
      double(:article,
        graph_id:        article_graph_id,
        title:           article_title_text,
        article_summary: '## This is a test summary.',
        article_body:    article_body_text
      )
    )
  }

  let!(:subcollection) {
    assign(:subcollection,
      double(:subcollection,
        name:        subcollection_name_text,
        graph_id:    'asdf1234',
      )
    )
  }

  let!(:collections) {
    assign(:collections,
      [
        double(:collections,
          name:           collection_name_text,
          description:    '**This** is a test description of a Collection.',
          graph_id:       'h93dvh57',
          subcollections: [subcollection],
          articles:       [
            double(:article,
              article_title:   article_title_text,
              graph_id:        article_graph_id
            ),
            double(:article2,
              article_title:    collection_article_title_text,
              graph_id:         'gj7e0ikd'
            )
          ]
        )
      ]
    )
  }

  let!(:article_graph_id)              { 'a3d21x98' }
  let!(:article_title_text)            { 'This is a test Title.' }
  let!(:article_body_text)             { '__This__ is an article body' }
  let!(:collection_name_text)          { 'This is a test Collection.' }
  let!(:collection_article_title_text) { 'Another article title' }
  let!(:subcollection_name_text)       { 'Test Subcollection' }

  before(:each) do
    render
  end

  context 'partials' do
    %w(header main footer).each do |template|
      it "will render the shared/article/#{template} partial" do
        expect(response).to render_template(partial: "shared/article/_#{template}")
      end
    end

    context 'when collections exist' do
      it 'will render the shared/article/aside_block link partial for each collection' do
        expect(response).to render_template(partial: 'shared/article/_aside_block', count: collections.size)
      end
    end

    context 'when collections do not exist' do
      let!(:collections) {
        assign(:collections, [])
      }
      it 'will not render the shared/article/aside_block partial' do
        expect(response).not_to render_template(partial: 'shared/article/_aside_block')
      end
    end
  end
end
