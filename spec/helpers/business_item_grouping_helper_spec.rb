require_relative '../rails_helper'

RSpec.describe BusinessItemGroupingHelper do

  it 'has a class called BusinessItemGroupedObject' do
    expect(BusinessItemGroupingHelper::BusinessItemGroupedObject).to be_a(Class)
  end

  describe '#group' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(BusinessItemGroupingHelper.group([], :grouping, :name)).to eq([])
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:node2) { double('node2', :type => 'BusinessItem', :date => DateTime.new(2015, 2, 16))}
      let(:node3) { double('node3', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:node4) { double('node4', :type => 'BusinessItem', :date => DateTime.new(2013, 1, 7))}
      let(:node5) { double('node5', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:node6) { double('node6', :type => 'BusinessItem', :date => nil)}
      let(:node7) { double('node7', :type => 'BusinessItem', :date => nil)}
      let(:data)  {[node2, node1, node5, node4, node7, node3, node6]}

      it 'returns an array of grouped, ungrouped and unknown data' do
        expect(BusinessItemGroupingHelper.group(data, :date).length).to eq(5)
      end
    end
  end

  describe '#create_sorted_array' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(BusinessItemGroupingHelper.create_sorted_array({})).to eq([])
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:node3) { double('node2', :type => 'BusinessItem', :date => DateTime.new(2015, 2, 16))}
      let(:node2) { double('node3', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:node4) { double('node4', :type => 'BusinessItem', :date => nil)}
      let(:node5) { double('node5', :type => 'BusinessItem', :date => nil)}
      let(:data_hash) {{
        DateTime.new(2017, 4, 8)  => [node1, node3],
        DateTime.new(2015, 2, 16) => [node3],
        'UNKNOWN'                 => [node4, node5]
      }}

      it 'returns an array of grouped objects' do
        expect(BusinessItemGroupingHelper.create_sorted_array(data_hash).length).to eq(4)
      end
    end
  end

  describe '#create_grouped_objects' do
    before(:each) do
      @grouped = BusinessItemGroupingHelper.create_grouped_objects(data_hash, DateTime.new(2017, 4, 8))
    end

    context 'with data' do
      let(:node1) { double('node1', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:node2) { double('node4', :type => 'BusinessItem', :date => DateTime.new(2017, 4, 8))}
      let(:data_hash) {{
        DateTime.new(2017, 4, 8) => [node1, node2]
      }}

      it 'returns a non-empty array' do
        expect(@grouped.length).to eq 1
      end

      it 'of BusinessItemGroupingHelper::BusinessItemGroupedObject class' do
        expect(@grouped[0].class).to eq(BusinessItemGroupingHelper::BusinessItemGroupedObject)
      end

      it 'with nodes that have been grouped' do
        expect(@grouped[0].nodes).to eq([node1, node2])
      end

      it 'with a date' do
        expect(@grouped[0].date).to eq(DateTime.new(2017, 4, 8))
      end

      it 'with a type' do
        expect(@grouped[0].type).to eq('BusinessItem')
      end
    end
  end
end
