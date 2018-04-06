require 'rails_helper'

RSpec.describe 'shared/article/_footer' do
  let!(:collections) do
    assign(:collections,
      [
        double(:collection,
          name:     'Collection name',
          graph_id: 'xxxxxxx1'),
        double(:collection,
          name:     'Another collection name',
          graph_id: 'xxxxxxx2')
      ])
  end

  before(:each) do
    render partial: 'shared/article/footer', locals: { collections: collections }
  end

  context 'footer' do
    context 'when collections exist' do
      it "will render 'up to' text" do
        expect(rendered).to match(/Up to/)
      end
    end

    context 'when collections do not exist' do
      let!(:collections) do
        assign(:collections, [])
      end
      it "will not render 'up to' text" do
        expect(rendered).not_to match(/Up to/)
      end
    end
  end
end
