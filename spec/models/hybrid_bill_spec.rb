require_relative '../spec_helper'

RSpec.describe HybridBill do
  before :each do
    stub_const('HybridBill::HYBRID_BILLS', { '1234' => described_class.new(Time.utc(2017,12,1,12,0,0), Time.utc(2017,12,1,13,0,0), Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,15,0,0)) })
  end

  after :each do
    Timecop.return
  end

  describe '#find' do
    context 'with a valid ID' do
      it 'returns a HybridBill object' do
        expect(described_class.find(1234)).to be_a(described_class)
      end
    end

    context 'with an invalid ID' do
      it 'returns nil' do
        expect(described_class.find(1337)).to be_nil
      end
    end
  end

  describe '#status' do
    context 'on the class' do
      before :each do
        Timecop.freeze(Time.utc(2017,12,1,13,0,0))
      end

      context 'with a valid ID' do
        it 'returns :active' do
          expect(described_class.status(1234)).to eq(:active)
        end
      end

      context 'with an invalid ID' do
        it 'returns nil' do
          expect(described_class.status(1337)).to be_nil
        end
      end
    end

    context 'on an instance' do
      before :each do
        @instance = described_class.new(Time.utc(2017,12,1,12,0,0), Time.utc(2017,12,1,13,0,0), Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,15,0,0))
      end

      it 'returns the expected status' do
        Timecop.freeze(Time.utc(2017,12,1,12,0,0))
        expect(@instance.status).to eq(:pre)


        Timecop.freeze(Time.utc(2017,12,1,13,0,0))
        expect(@instance.status).to eq(:active)


        Timecop.freeze(Time.utc(2017,12,1,14,0,0))
        expect(@instance.status).to eq(:post)


        Timecop.freeze(Time.utc(2017,12,1,15,0,0))
        expect(@instance.status).to eq(:closed)
      end
    end
  end

  describe '#initialize' do
    context 'with valid phases' do
      it 'sets the expected instance variables' do
        instance = described_class.new(Time.utc(2017,12,1,12,0,0), Time.utc(2017,12,1,13,0,0), Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,15,0,0))

        expect(instance.instance_variable_get(:@pre_phase_start)).to eq(Time.utc(2017,12,1,12,0,0))
        expect(instance.instance_variable_get(:@active_phase_start)).to eq(Time.utc(2017,12,1,13,0,0))
        expect(instance.instance_variable_get(:@post_phase_start)).to eq(Time.utc(2017,12,1,14,0,0))
        expect(instance.instance_variable_get(:@closed_phase_start)).to eq(Time.utc(2017,12,1,15,0,0))
      end
    end

    context 'within invalid phases' do
      context 'pre after active' do
        it 'raises an ArgumentError' do
          expect{
            described_class.new(Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,13,0,0), Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,15,0,0))
          }.to raise_error 'Each phase must occur AFTER the previous phase.'
        end
      end


      context 'active after post' do
        it 'raises an ArgumentError' do
          expect{
            described_class.new(Time.utc(2017,12,1,12,0,0), Time.utc(2017,12,1,15,0,0), Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,15,0,0))
          }.to raise_error 'Each phase must occur AFTER the previous phase.'
        end
      end


      context 'post after closed' do
        it 'raises an ArgumentError' do
          expect{
            described_class.new(Time.utc(2017,12,1,14,0,0), Time.utc(2017,12,1,13,0,0), Time.utc(2017,12,1,16,0,0), Time.utc(2017,12,1,15,0,0))
          }.to raise_error 'Each phase must occur AFTER the previous phase.'
        end
      end
    end
  end

  describe '#pre?' do
    it 'returns the expected values' do
      Timecop.freeze(Time.utc(2017,12,1,11,59,59))
      expect(described_class.find(1234).pre?).to eq(false)

      Timecop.freeze(Time.utc(2017,12,1,12,0,0))
      expect(described_class.find(1234).pre?).to eq(true)

      Timecop.freeze(Time.utc(2017,12,1,13,0,0))
      expect(described_class.find(1234).pre?).to eq(false)
    end
  end

  describe '#active?' do
    it 'returns the expected values' do
      Timecop.freeze(Time.utc(2017,12,1,12,59,59))
      expect(described_class.find(1234).active?).to eq(false)

      Timecop.freeze(Time.utc(2017,12,1,13,0,0))
      expect(described_class.find(1234).active?).to eq(true)

      Timecop.freeze(Time.utc(2017,12,1,14,0,0))
      expect(described_class.find(1234).active?).to eq(false)
    end
  end

  describe '#post?' do
    it 'returns the expected values' do
      Timecop.freeze(Time.utc(2017,12,1,13,59,59))
      expect(described_class.find(1234).post?).to eq(false)

      Timecop.freeze(Time.utc(2017,12,1,14,0,0))
      expect(described_class.find(1234).post?).to eq(true)

      Timecop.freeze(Time.utc(2017,12,1,15,0,0))
      expect(described_class.find(1234).post?).to eq(false)
    end
  end

  describe '#closed?' do
    it 'returns the expected values' do
      Timecop.freeze(Time.utc(2017,12,1,14,59,59))
      expect(described_class.find(1234).closed?).to eq(false)

      Timecop.freeze(Time.utc(2017,12,1,15,0,0))
      expect(described_class.find(1234).closed?).to eq(true)
    end
  end
end
