require 'rails_helper'

RSpec.describe 'houses', type: :routing do
  describe 'HousesController' do
    # houses#lookup
    include_examples 'top level routes', 'houses', 'lookup'

    context 'house' do
      # houses#show
      include_examples 'nested routes with an id', 'houses', 'KL2k1BGP', [], 'show'

      context 'parties' do
        it 'GET houses#show' do
          expect(get: '/houses/KL2k1BGP/parties/jF43Jxoc').to route_to(
          controller: 'houses/parties',
          action:     'show',
          house_id:   'KL2k1BGP',
          party_id:   'jF43Jxoc'
          )
        end
      end
    end
  end
end
