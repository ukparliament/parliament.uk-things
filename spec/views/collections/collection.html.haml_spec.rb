require 'rails_helper'

RSpec.describe 'collections/_collection' do
  let!(:subcollection) {
    assign(:subcollection,
      double(:subcollection,
        name:        subcollection_name_text,
        graph_id:    'asdf1234',
      )
    )
  }

  let!(:article) {
    assign(:article,
      double(:article,
        article_title:   article_title_text,
        article_summary: article_summary_text,
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
        articles:       [article],
        parents:        [parent_collection]
      )
    )
  }

  let!(:parent_collection) {
    assign(:parent_collection,
      double(:parent_collection,
        name:     'Test parent collection',
        graph_id: 'test1234'
      )
    )
  }

  let!(:collection_name_text) { 'This is a test Collection.' }
  let!(:collection_description_text) { '**This** is a test description of a Collection.' }
  let!(:subcollection_name_text) { 'This is a test subcollection name' }
  let!(:article_title_text) { 'This is a test Title.' }
  let!(:article_summary_text) { '**This** is an article summary' }

  before(:each) do
    render partial: "collections/collection", locals: { collection: collection }
  end

  context 'collection' do
    context 'converted to HTML' do
      it 'name will render correctly' do
        expect(rendered).to match(/<h1>This is a test Collection.<\/h1>/)
      end

      it 'description will render correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is a test description of a Collection.<\/p>/)
      end
    end

    context 'sanitize' do
      let!(:collection_name_text) { '<script>This is a test Collection name.</script>' }
      let!(:collection_description_text) { '<script>__This__ is a Collection description</script>' }

      it 'sanitized name will render correctly' do
        expect(rendered).to match(/<h1>This is a test Collection name.<\/h1>/)
      end

      it 'sanitized description will render correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is a Collection description<\/p>/)
      end
    end
  end

  context 'articles' do
    context 'converted to HTML' do
      it 'will render articles' do
        expect(rendered).to match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:article_title_text) { '<script>This is a test Title.</script>' }
      let!(:article_summary_text) { '<script>__This__ is an article summary</script>' }

      it 'will render the sanitized link to articles' do
        expect(rendered).to match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end
    end
  end

  context 'subcollections' do
    context 'converted to HTML' do
      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:subcollection_name_text) { '<script>This is a test subcollection name.</script>' }

      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name.<\/a>/)
      end
    end
  end

  context 'partials' do
    context 'when parent collections exist' do
      it 'will render the collections/delimited_links partial' do
        expect(response).to render_template(partial: 'collections/_delimited_links')
      end
    end

    context 'when parent collections do not exist' do
      let!(:collection) {
        assign(:collection,
          double(:collection,
            name:           collection_name_text,
            description:    collection_description_text,
            subcollections: [],
            articles:       [],
            parents:        []
          )
        )
      }

      it 'will not render the collections/delimited_links partial' do
        expect(response).not_to render_template(partial: 'collections/_delimited_links')
      end
    end
  end

  context 'footer' do
    context 'when collections exist' do
      it "will render 'up to' text" do
        expect(rendered).to match(/Up to/)
      end
    end

    context 'when collections do not exist' do
      let!(:collection) {
        assign(:collection,
          double(:collection,
            name:           collection_name_text,
            description:    collection_description_text,
            subcollections: [],
            articles:       [],
            parents:        []
          )
        )
      }

      it "will not render 'up to' text" do
        expect(rendered).not_to match(/Up to/)
      end
    end
  end
end
