require 'rails_helper'

RSpec.describe 'articles/show', vcr: true do
  let!(:article) {
    assign(:article,
      double(:article,
        title:           article_title_text,
        article_summary: '## This is a test summary.',
        article_body:    article_body_text
      )
    )
  }

  let!(:related_articles) {
    assign(:related_articles,
      [
        double(:related_articles,
          article_title: related_article_title_text,
          graph_id:      '1234abcd'
        )
      ]
    )
  }

  let!(:collections) {
    assign(:collections,
      [
        double(:collections,
          name:        collection_name_text,
          description: '**This** is a test description of a Collection.',
          graph_id:    'h93dvh57',
          articles:    [
            double(:article2,
              article_title:    collection_article_title_text,
              graph_id: 'gj7e0ikd'
            )
          ]
        )
      ]
    )
  }

  before(:each) do
    render
  end

  context 'valid data' do
    let!(:article_title_text)            { 'This is a test Title.' }
    let!(:article_body_text)             { '__This__ is an article body' }
    let!(:related_article_title_text)    { 'Related article title' }
    let!(:collection_name_text)          { 'This is a test Collection.' }
    let!(:collection_article_title_text) { 'Another article title' }

    context 'converted to HTML' do
      context 'article' do
        it 'will render the article title correctly' do
          expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
        end

        it 'will render the article summary correctly' do
          expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
        end

        it 'will render the article body correctly' do
          expect(rendered).to match(/<p><strong>This<\/strong> is an article body<\/p>/)
        end
      end

      context 'related articles' do
        it 'displays the correct header' do
          expect(rendered).to match(/Related Articles/)
        end

        it 'will render a link to related articles' do
          expect(rendered).to match(/<a href="\/articles\/1234abcd">Related article title<\/a>/)
        end
      end

      context 'collections' do
        it 'displays the correct header' do
          expect(rendered).to match(/Collections this article belongs to/)
        end

        it 'will render a link to collections that article belongs to' do
          expect(rendered).to match(/<a href="\/collections\/h93dvh57">This is a test Collection.<\/a>/)
        end
      end
    end
  end

  context 'sanitize' do
    let!(:article_title_text)            { '<script>This is a test Title.</script>' }
    let!(:article_body_text)             { '<script>__This__ is an article body</script>' }
    let!(:related_article_title_text)    { '<script>Related article title</script>' }
    let!(:collection_name_text)          { '<script>This is a test Collection.</script>' }
    let!(:collection_article_title_text) { '<script>Another article title</script>' }

    context 'article' do
      it 'will render the sanitized article title correctly' do
        expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
      end

      it 'will render the sanitized article summary correctly' do
        expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
      end

      it 'will render the sanitized article body correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is an article body<\/p>/)
      end
    end

    context 'related articles' do
      it 'will render the sanitized related articles correctly' do
        expect(rendered).to match(/<a href="\/articles\/1234abcd">Related article title<\/a>/)
      end
    end

    context 'collections' do
      it 'will render the collections correctly' do
        expect(rendered).to match(/<a href="\/collections\/h93dvh57">This is a test Collection.<\/a>/)
      end
    end
  end
end
