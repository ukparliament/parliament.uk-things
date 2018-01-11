require 'rails_helper'

RSpec.shared_context 'successful show response' do
  before do
    get :show, params: { bill_id: '1234' }
  end

  it 'with 200 status code' do
    expect(response).to have_http_status(200)
  end
end

RSpec.shared_context 'the current stage template' do
  before do
    get :show, params: { bill_id: '1234', status: stage }
  end

  it 'renders correctly' do
    expect(response).to render_template(page)
  end
end

RSpec.shared_context 'the not current stage template' do
  before do
    get :show, params: { bill_id: '1234', status: stage }
  end

  it 'does not render correctly' do
    expect(response).not_to render_template(page)
  end
end