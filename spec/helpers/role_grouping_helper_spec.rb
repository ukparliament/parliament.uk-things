require_relative '../rails_helper'

RSpec.describe RoleGroupingHelper do

  it 'has a class called BusinessItemGroupedObject' do
    expect(RoleGroupingHelper::RoleGroupedObject).to be_a(Class)
  end

  describe '#group' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(RoleGroupingHelper.group([], :grouping, :name)).to eq([])
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :start_date => DateTime.new(2015, 5, 7), :type => 'FormalBody', :end_date => DateTime.new(2017, 4, 8), :grouping => double(:name, :name => 'test'))}
      let(:node2) { double('node2', :start_date => DateTime.new(1990, 6, 8), :type => 'FormalBody', :end_date => DateTime.new(1994, 5, 9), :grouping => double(:name, :name => 'test'))}
      let(:node3) { double('node3', :start_date => DateTime.new(2005, 4, 5), :type => 'FormalBody', :grouping => double(:name, :name => 'banana'))}
      let(:node4) { double('node4', :start_date => DateTime.new(2015, 5, 7), :type => 'FormalBody', :end_date => DateTime.new(2017, 9, 11), :grouping => double(:name, :name => 'banana'))}
      let(:node5) { double('node5', :start_date => DateTime.new(2007, 3, 23), :type => 'FormalBody', :end_date => DateTime.new(2016, 2, 1), :grouping => double(:name, :name => 'banana'))}
      let(:node6) { double('node6', :start_date => DateTime.new(2002, 9, 2), :type => 'FormalBody', :end_date => DateTime.new(2015, 3, 4), :grouping => double(:name, :name => 'ungrouped'))}
      let(:node7) { double('node7', :start_date => DateTime.new(2004, 5, 20), :type => 'FormalBody', :end_date => DateTime.new(2013, 2, 5), :grouping => double(:name, :name => nil))}
      let(:data) {[node2, node1, node5, node4, node7, node3, node6]}

      it 'returns an array of grouped, ungrouped and unknown data' do
        expect(RoleGroupingHelper.group(data, :grouping, :name).length).to eq(4)
      end
    end
  end

  describe '#create_sorted_array' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(RoleGroupingHelper.create_sorted_array({})).to eq([])
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :start_date => 2015, :end_date => 2017, :type => 'SeatIncumbency', :grouping => double(:name, :name => 'test'))}
      let(:node2) { double('node2', :start_date => 2015, :end_date => 2016, :type => 'SeatIncumbency', :grouping => double(:name, :name => 'banana'))}
      let(:node3) { double('node3', :start_date => 1990, :end_date => 1994, :type => 'SeatIncumbency', :grouping => double(:name, :name => 'test'))}
      let(:node4) { double('node4', :start_date => 2015, :end_date => 2017, :type => 'SeatIncumbency', :grouping => double(:name, :name => nil))}
      let(:node5) { double('node5', :start_date => 2013, :end_date => 2014, :type => 'SeatIncumbency', :grouping => double(:name, :name => nil))}
      let(:data_hash) {{
        'test'    => [node1, node3],
        'banana'  => [node2],
        'UNKNOWN' => [node4, node5]
      }}

      it 'returns an array of grouped objects' do
        expect(RoleGroupingHelper.create_sorted_array(data_hash).length).to eq(4)
      end
    end
  end

  describe '#create_grouped_objects' do
    context 'with data' do
      let(:node1) { double('node1', :start_date => DateTime.new(2015, 5, 7), :type => 'SeatIncumbency', :end_date => DateTime.new(2017, 4, 8))}
      let(:node2) { double('node2', :start_date => DateTime.new(1990, 6, 8), :type => 'SeatIncumbency', :end_date => DateTime.new(1994, 5, 9))}
      let(:node4) { double('node4', :start_date => DateTime.new(2015, 5, 7), :type => 'SeatIncumbency', :end_date => DateTime.new(2017, 9, 11))}
      let(:node5) { double('node5', :start_date => DateTime.new(2007, 3, 23), :type => 'SeatIncumbency', :end_date => nil)}
      let(:data_hash) {{
        'apple' => [node1, node2],
        'test' => [node4, node5]
      }}

      it 'returns a non-empty array' do
        grouped = RoleGroupingHelper.create_grouped_objects(data_hash, 'apple')
        expect(grouped.length).to eq 1
      end

      it 'of RoleGroupingHelper::RoleGroupedObject class' do
        grouped = RoleGroupingHelper.create_grouped_objects(data_hash, 'apple')
        expect(grouped[0].class).to eq(RoleGroupingHelper::RoleGroupedObject)
      end

      it 'with nodes that have been grouped' do
        grouped = RoleGroupingHelper.create_grouped_objects(data_hash, 'apple')
        expect(grouped[0].nodes).to eq([node1, node2])
      end

      it 'with a start date' do
        grouped = RoleGroupingHelper.create_grouped_objects(data_hash, 'apple')
        expect(grouped[0].start_date).to eq(DateTime.new(1990, 6, 8))
      end

      it 'with an end date' do
        grouped = RoleGroupingHelper.create_grouped_objects(data_hash, 'apple')
        expect(grouped[0].end_date).to eq(DateTime.new(2017, 4, 8))
      end

      it 'with a type' do
        grouped = RoleGroupingHelper.create_grouped_objects(data_hash, 'apple')
        expect(grouped[0].type).to eq('SeatIncumbency')
      end
    end
  end
end
