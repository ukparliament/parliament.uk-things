require_relative '../rails_helper'

RSpec.describe HybridBillsHelper do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  describe '#create_session' do
    it { expect(subject.create_session).to eq(true) }
  end

  # describe '#get_response' do
  #   let(:url) { HybridBillsHelper::API::TEST }
  #
  #   subject {HybridBillsHelper.get_response(@url)}
  #
  #   it 'returns a json object' do
  #     expect(subject).to eq({
  #        "userId": 1,
  #      "id": 1,
  #    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  #    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  #     })
  #   end
  # end
end

