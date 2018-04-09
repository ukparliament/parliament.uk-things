require 'rails_helper'

RSpec.describe 'collections/show', vcr: true do
  let!(:collection) {
    assign(:collection,
      double(:collection,
        name:                 'Test collection',
        description:          'Test collection description',
        extended_description: 'Test extended collection description',
        graph_id:             'fghj76kl',
        parents:              [parent_collection],
        articles:             [],
        subcollections:       []
      )
    )
  }

  let!(:parent_collection) {
    assign(:parent_collection,
      double(:parent_collection,
        name:     'Test Parent',
        graph_id: 'v6v7b8b8'
      )
    )
  }

  let!(:root_collections) {
    assign(:root_collections, [])
  }

  before(:each) do
    render
  end

  context 'partials' do
    context 'when a collection has at least one parent collection' do
      it "renders the 'collection' partial" do
        expect(response).to render_template(partial: 'collections/_collection')
      end
    end

    context 'when a collection is the root (has no parents)' do
      let!(:collection) {
        assign(:collection,
          double(:collection,
            name:                 'Test collection',
            description:          'Test collection description',
            extended_description: 'Test collection extended description',
            graph_id:             'fghj76kl',
            parents:              [],
            articles:             [],
            subcollections:       []
          )
        )
      }

      it "renders the 'root_collection' partial" do
        expect(response).to render_template(partial: 'collections/_root_collection')
      end
    end
  end

end
