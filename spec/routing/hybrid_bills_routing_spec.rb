require 'rails_helper'

RSpec.describe 'hybrid_bills', vcr: :false, type: :routing do
  WebMock.disable_net_connect!
  describe 'HybridBillsController' do
    context 'index' do
      it 'GET hybrid_bills#index' do
        expect(get: '/petition-a-hybrid-bill').to route_to('hybrid_bills#index')
      end
    end

    context 'show' do
      it 'GET hybrid_bills#show' do
        expect(get: '/petition-a-hybrid-bill/1234').to route_to('hybrid_bills#show', bill_id: '1234')
      end
    end

    context 'choose_type' do
      it 'GET hybrid_bills#redirect' do 
        expect(post: '/petition-a-hybrid-bill/1234/email-a-petition').to route_to('hybrid_bills#choose_type', bill_id: '1234')
      end
    end

    context 'redirect' do
      it 'GET hybrid_bills#redirect' do 
        expect(get: '/petition-a-hybrid-bill/1234/complete-your-petition-online').to route_to('hybrid_bills#redirect', bill_id: '1234')
      end
    end
  end
end