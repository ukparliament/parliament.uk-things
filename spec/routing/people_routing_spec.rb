require 'rails_helper'

RSpec.describe 'people', type: :routing do
  describe 'PeopleController' do
    context 'people' do
      # people#lookup
      include_examples 'top level routes', 'people', 'lookup'

      # people#postcode_lookup
      include_examples 'top level POST routes', 'people', 'postcode_lookup'
    end

    context 'person' do
      # people#show
      include_examples 'nested routes with an id', 'people', 'B4qvo8kI', [], 'show'
    end
  end
end
