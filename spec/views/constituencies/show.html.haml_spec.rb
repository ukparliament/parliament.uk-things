require 'rails_helper'

RSpec.describe 'constituencies/show', vcr: true do
  before do
    assign(:seat_incumbencies,
      [double(:seat_incumbencies,
        start_date: nil,
        end_date:   nil,
        current?:   true)])
  end

  context 'no region information' do
    before do
      assign(:constituency,
        double(:constituency,
          name:       'Aberavon',
          graph_id:   'MtbjxRrE',
          start_date: nil,
          end_date:   nil,
          current?:   true,
          date_range: 'from 2010',
          regions: []))
      render
    end

    it 'will not show region of constituency if not available' do
      expect(rendered).not_to match(/Constituency in/)
    end
  end

  context 'region information' do
    before do
      assign(:constituency,
        double(:constituency,
          name:       'Aberavon',
          graph_id:   'MtbjxRrE',
          start_date: nil,
          end_date:   nil,
          current?:   true,
          date_range: 'from 2010',
          regions: [double(:region,
            name:     'Scotland',
            gss_code: 'S15000001')]))
      render
    end

    context 'header' do
      it 'will render the correct header' do
        expect(rendered).to match(/Aberavon/)
      end
    end

    context 'sub-header' do
      it 'will show region of constituency if available' do
        expect(rendered).to match(/Constituency in/)
      end
    end

    context 'partials' do
      it 'will render constituencies/constituencies' do
        expect(response).to render_template(partial: 'constituencies/_constituency')
      end
    end
  end
end
