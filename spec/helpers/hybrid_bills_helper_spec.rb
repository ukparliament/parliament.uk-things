require_relative '../rails_helper'

RSpec.describe HybridBillsHelper do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  describe '#api_request' do
    it { expect(subject.api_request).to be_a(Parliament::Request::BaseRequest) }
  end
end

