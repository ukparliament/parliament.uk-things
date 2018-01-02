require 'rails_helper'

RSpec.shared_context 'successful show response' do
  before do
    get :show, params: { bill_id: '1234' }
  end

  it 'with 200 status code' do
    expect(response).to have_http_status(200)
  end
end

RSpec.shared_context 'the expected hybrid bill stage' do |id, stage, page|
  before do
    get :show, params: { bill_id: id, status: stage }
  end

  it "renders '#{page}' correctly in '#{stage}' stage" do
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
