require 'rails_helper'

RSpec.describe 'parties', type: :routing do
  describe 'PartiesController' do
    # parties#lookup
    include_examples 'top level routes', 'parties', 'lookup'

    context 'party' do
      # parties#show
      include_examples 'nested routes with an id', 'parties', 'jF43Jxoc', [], 'show'
    end
  end
end
