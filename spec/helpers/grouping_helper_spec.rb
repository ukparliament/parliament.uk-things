require_relative '../rails_helper'

RSpec.describe GroupingHelper do
  describe '#group_data' do
    context 'with no data' do
      it 'returns a hash' do
        expect(group_data([], [:grouping, :name])).to be_a(Hash)
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :start_date => 2015, :end_date => 2017, :type => 'SeatIncumbency', :grouping => double(:name, :name => 'test'))}
      let(:node2) { double('node2', :start_date => 2015, :end_date => 2016, :type => 'SeatIncumbency', :grouping => double(:name, :name => 'banana'))}
      let(:node3) { double('node3', :start_date => 1990, :end_date => 1994, :type => 'SeatIncumbency', :grouping => double(:name, :name => 'test'))}
      let(:node4) { double('node4', :start_date => 2015, :end_date => 2017, :type => 'SeatIncumbency', :grouping => double(:name, :name => nil))}
      let(:node5) { double('node5', :start_date => 2013, :end_date => 2014, :type => 'SeatIncumbency', :grouping => double(:name, :name => nil))}
      let(:data) {[node2, node1, node5, node4, node3]}

      it 'returns an array of grouped and ungrouped objects' do
        expect(group_data(data, [:grouping, :name])).to eq({
          'test' => [node1, node3],
          'banana' => [node2],
          'UNKNOWN' => [node5, node4]
        })
      end
    end
  end

  describe '#create_sorted_array' do
    # Tested in separate Helper classes
  end


  describe '#group' do
    # Tested in separate Helper classes
  end
end
