require_relative '../rails_helper'

RSpec.describe HistoryHelper do
  before(:each) do
    Timecop.freeze(DateTime.new(2017, 9, 18))
  end

  after(:each) do
    HistoryHelper.reset
    Timecop.return
  end

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  describe '#history' do
    it 'returns a history hash' do
      expect(subject.history).to eq({
        start: nil,
        current: [],
        years: {}
      })
    end
  end

  describe '#add' do
    context 'when adding no data' do
      it 'does nothing' do
        history = subject.history
        subject.add(nil)
        expect(subject.history).to eq(history)
      end
    end

    context 'when adding' do
      before(:each) do
        @history = HistoryHelper.history
      end

      context 'valid data' do
        let(:node1) { double('node1', :start_date => DateTime.new(2015, 5, 7), :end_date => DateTime.new(2017, 4, 8))}
        let(:node2) { double('node2', :start_date => DateTime.new(1990, 6, 8), :end_date => DateTime.new(1994, 5, 9))}
        let(:node3) { double('node3', :start_date => DateTime.new(2005, 4, 5))}
        let(:node4) { double('node4', :start_date => DateTime.new(2015, 5, 7), :end_date => DateTime.new(2017, 9, 11))}
        let(:node5) { double('node5', :start_date => DateTime.new(2007, 3, 23))}
        let(:data) {[node1, node2, node3, node4, node5]}

        it 'adds to history' do
          subject.add(data)
          expect(subject.history).to eq({
            start: DateTime.new(1990, 6, 8),
            current: [node5, node3],
            years: {10 => [node4, node1], 30 => [node2]}
          })
        end
      end

      context 'invalid data' do
        context 'with an empty array' do
          let(:data) {[]}

          it 'adds nothing to history' do
            subject.add(data)
            expect(subject.history).to eq(@history)
          end
        end
      end

      context 'with incorrect start and end dates' do
        let(:data) do
          [
            double('node', :end_date => DateTime.new(2017, 4, 8)),
            double('node', :end_date => 'foo'),
            double('node', :start_date => nil, :end_date => DateTime.new(2017, 4, 8)),
            double('node', :start_date => 'bar', :end_date => DateTime.new(2017, 4, 8)),
            double('node', :start_date => 'bar')
          ]
        end

        it 'adds nothing to history' do
          subject.add(data)
          expect(subject.history).to eq(@history)
        end
      end
    end

    describe '#sort_history' do
      context 'with no data' do
        it 'does nothing' do
          subject.add([])
          expect(subject.history).to eq({
            start: nil,
            current: [],
            years: {}
            })
        end
      end

      context 'with data' do
        let(:node1) { double('node1', :start_date => DateTime.new(2015, 5, 7), :end_date => DateTime.new(2014, 4, 8))}
        let(:node2) { double('node2', :start_date => DateTime.new(1990, 6, 8), :end_date => DateTime.new(2014, 4, 8))}
        let(:node3) { double('node3', :start_date => DateTime.new(2015, 5, 7), :end_date => DateTime.new(2017, 7, 26))}
        let(:data) { [node2, node1, node3] }

        before(:each) do
          subject.add(data)
        end

        it 'sorts first by end date' do
          expect(subject.history[:years][10][0]).to eq(node3)
        end

        it 'sorts by start date if same end date' do
          expect(subject.history[:years][10][1]).to eq(node1)
        end
      end
    end
  end
end
