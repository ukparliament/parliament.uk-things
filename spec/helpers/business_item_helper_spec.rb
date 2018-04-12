RSpec.describe BusinessItemHelper do
  describe '#arrange_by_date' do
    context 'with no data' do
      it 'returns three empty arrays' do
        expect(BusinessItemHelper.arrange_by_date([])).to eq([ [], [], [] ])
      end
    end
  end

  describe '#sort_by_date' do
    context 'with no data' do
      it 'returns an empty array' do
        expect(BusinessItemHelper.sort_by_date([])).to eq([])
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :date => DateTime.new(2018, 06, 04)) }
      let(:node2) { double('node2', :date => DateTime.new(2017, 12, 23)) }
      let(:node3) { double('node3', :date => nil) }
      let(:data)  {[node1, node2, node3]}

      it 'returns an array of date ordered nodes, those with no dates at the start' do
        expect(BusinessItemHelper.sort_by_date(data)).to eq([ node3, node2, node1 ])
      end
    end
  end

  describe '#split_by_date' do
    before(:each) do
      Timecop.freeze(DateTime.new(2018, 04, 01))
    end

    context 'with no data' do
      it 'returns three empty arrays' do
        expect(BusinessItemHelper.split_by_date([])).to eq([ [], [], [] ])
      end
    end

    context 'with data' do
      let(:node1) { double('node1', :date => DateTime.new(2018, 06, 04)) }
      let(:node2) { double('node2', :date => DateTime.new(2017, 12, 23)) }
      let(:node3) { double('node3', :date => nil) }
      let(:data)  {[node1, node2, node3]}

      it 'firstly returns an array of completed business items' do
        expect(BusinessItemHelper.split_by_date(data)[0]).to eq([node2])
      end

      it 'secondly returns an array of scheduled (future) business items' do
        expect(BusinessItemHelper.split_by_date(data)[1]).to eq([node1])
      end

      it 'lastly returns an array of business items with no date' do
        expect(BusinessItemHelper.split_by_date(data)[2]).to eq([node3])
      end
    end
  end
end
