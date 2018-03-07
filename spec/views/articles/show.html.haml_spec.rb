require 'rails_helper'

RSpec.describe 'articles/show', vcr: true do
  context 'valid data' do
    before do
      assign(:article,
        double(:article,
          title:           'This is a test Title.',
          article_summary: '## This is a test summary.',
          article_body:    '__This__ is an article body'
        )
      )

      assign(:related_articles,
        [
          double(:related_articles,
            article_title: 'Related article title',
            graph_id:      '1234abcd'
          )
        ]
      )

      render
    end

    context 'converted to HTML' do
      it 'will render the article correctly' do
        expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
        expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
        expect(rendered).to match(/<p><strong>This<\/strong> is an article body<\/p>/)
      end

      it 'will render the related articles' do
        expect(rendered).to match(/<a href="\/articles\/1234abcd">Related article title<\/a>/)
      end
    end
  end

  context 'sanitize' do
    before do
      assign(:article,
        double(:article,
          title:           '<script>This is a test Title.</script>',
          article_summary: '## This is a test summary.',
          article_body:    '<script>__This__ is an article body</script>'
        )
      )

      assign(:related_articles,
        [
          double(:related_articles,
            article_title: '<script>Related article title</script>',
            graph_id:      'abcd1234'
          )
        ]
      )

      render
    end

    context 'article' do
      it 'will render the sanitized article correctly' do
        expect(rendered).to match(/<h1>This is a test Title.<\/h1>/)
        expect(rendered).to match(/<h2>This is a test summary.<\/h2>/)
        expect(rendered).to match(/<p><strong>This<\/strong> is an article body<\/p>/)
      end
    end

    context 'related articles' do
      it 'will render the sanitized related articles' do
        expect(rendered).to match(/<a href="\/articles\/abcd1234">Related article title<\/a>/)
      end
    end
  end
end
