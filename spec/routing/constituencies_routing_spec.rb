require 'rails_helper'

RSpec.describe 'constituencies', type: :routing do
  describe 'ConstituenciesController' do
    # constituencies#lookup
    include_examples 'top level routes', 'constituencies', 'lookup'

    # constituencies#postcode_lookup
    include_examples 'top level POST routes', 'constituencies', 'postcode_lookup'

    context 'constituency' do
      # constituencies#show
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', [], 'show'

      # constituencies#map
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', ['map'], 'map'
    end
  end
end
