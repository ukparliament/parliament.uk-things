require 'rails_helper'

RSpec.describe 'work_packages/_work_packageable_thing', vcr: true do
  let!(:work_packageable_thing) {
    assign(:work_packageable_thing,
           double(:work_packageable_thing,
                  workPackageableThingName:'Test work packageable thing name',
                  graph_id: 'A1234567'
           )
    )
  }

  context 'work_packageable_thing' do
    context 'with type Statutory Instrument Paper' do
      before(:each) do
        allow(work_packageable_thing).to receive(:is_a?).with(Parliament::Grom::Decorator::StatutoryInstrumentPaper).and_return(true)

        render
      end
      it 'displays the type' do
        expect(rendered).to match(/Statutory Instrument/)
      end

      it 'displays name' do
        expect(rendered).to match(/Test work packageable thing name/)
      end
    end

    context 'with type Proposed Negative Statutory Instrument Paper' do
      it 'displays the type' do
        allow(work_packageable_thing).to receive(:is_a?).with(Parliament::Grom::Decorator::StatutoryInstrumentPaper).and_return(false)
        allow(work_packageable_thing).to receive(:is_a?).with(Parliament::Grom::Decorator::ProposedNegativeStatutoryInstrumentPaper).and_return(true)

        render

        expect(rendered).to match(/Proposed Negative Statutory Instrument/)
      end
    end
  end
end
