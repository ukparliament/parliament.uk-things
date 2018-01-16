require 'rails_helper'

RSpec.shared_context 'the expected hybrid bill stage' do |id, status, page|
  before do
    params = { bill_id: id }
    params[:status] = status if status

    get :show, params: params
  end

  it "renders '#{page}' correctly in #{status ? "'#{status}'" : 'the current'} stage" do
    expect(response).to render_template(page)
  end
end

RSpec.shared_context 'a correct bill id' do 
 before do
      get :show, params: { bill_id: '1234' }
 end  

 it 'is ok' do 
    expect(response.request.path_parameters[:bill_id]).to eq('1234')
 end 

end  

RSpec.shared_context 'an incorrect bill id' do 
 it 'is not ok' do 
   expect {get :show, params: { bill_id: '90' }}.to raise_error(ActionController::RoutingError, 'invalid petition id')
 end 
end

RSpec.shared_context 'a hybrid bill simple step' do |id, step|
  it 'renders the expected template' do
    get :show, params: { bill_id: id, step: step }

    expect(response).to have_rendered("hybrid_bills/steps/#{step}")
  end
end

RSpec.shared_context 'a hybrid bill cover page form' do |id, step, type|
  it 'renders the expected template' do
    post :show, params: { bill_id: id, step: step, type: type }

    expect(response).to render_template("hybrid_bills/steps/forms/#{type}")
  end
end

          
