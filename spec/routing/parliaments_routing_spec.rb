require 'rails_helper'

RSpec.describe 'parliaments', type: :routing do
  describe 'ParliamentsController' do
    context 'parliaments' do
      # parliaments#current
      include_examples 'top level routes', 'parliaments', 'current'

      # parliaments#lookup
      include_examples 'top level routes', 'parliaments', 'lookup'

      # parliaments#next
      include_examples 'top level routes', 'parliaments', 'next'

      # parliaments#previous
      include_examples 'top level routes', 'parliaments', 'previous'

      context 'parliament' do
        context 'show' do
          # parliaments#show
          include_examples 'nested routes with an id', 'parliaments', 'KL2k1BGP', [], 'show'
        end

        context 'next parliament' do
          # parliaments#next_parliament
          include_examples 'nested routes with an id', 'parliaments', 'KL2k1BGP', ['next'], 'next_parliament'
        end

        context 'previous parliament' do
          # parliaments#previous_parliament
          include_examples 'nested routes with an id', 'parliaments', 'KL2k1BGP', ['previous'], 'previous_parliament'
        end

        context 'parties' do
          context 'party' do
            # parliaments/parties#show
            it "GET parliaments/parties#show" do
              expect(get: '/parliaments/KL2k1BGP/parties/12341234').to route_to(
                controller:    'parliaments/parties',
                action:        'show',
                parliament_id: 'KL2k1BGP',
                party_id:      '12341234'
              )
            end
          end
        end

        context 'houses' do
          context 'house' do
            # parliaments/houses#show
            it 'GET parliaments/houses#show' do
              expect(get: '/parliaments/KL2k1BGP/houses/12341234').to route_to(
                controller:    'parliaments/houses',
                action:        'show',
                parliament_id: 'KL2k1BGP',
                house_id:      '12341234'
              )
            end
          end

          context 'parties' do
            context 'party' do
              # parliaments/houses/parties#show
              it 'GET parliaments/houses/parties#show' do
                expect(get: '/parliaments/12341234/houses/12345678/parties/87654321').to route_to(
                  controller:    'parliaments/houses/parties',
                  action:        'show',
                  parliament_id: '12341234',
                  house_id:      '12345678',
                  party_id:      '87654321'
                )
              end
            end
          end
        end
      end
    end
  end
end
