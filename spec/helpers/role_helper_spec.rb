require_relative '../rails_helper'

RSpec.describe RoleHelper do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  context '#role_type' do
    namespace_uri = Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('FormalBodyMembership')
    let(:test_role) { double('test_role', :type => namespace_uri) }

    it 'returns true if role type is the same as role_type' do
      expect(subject.role_type(test_role, 'FormalBodyMembership')).to be(true)
    end

    it 'returns false if role type is not the same as role_type' do
      expect(subject.role_type(test_role, 'SeatIncumbency')).to be(false)
    end
  end
end
