require 'rails_helper'

RSpec.describe QuestionsController, vcr: true do
  describe 'GET show' do
    context 'with an answer' do
      before(:each) do
        get :show, params: { question_id: 'bKNLIS4T' }
      end

      it 'response have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @question' do
        expect(assigns(:question)).to be_a(Grom::Node)
        expect(assigns(:question).type).to eq('https://id.parliament.uk/schema/Question')
      end

      it 'assigns @answer' do
        expect(assigns(:answer)).to be_a(Grom::Node)
        expect(assigns(:answer).type).to eq('https://id.parliament.uk/schema/Answer')
      end

      it 'assigns @constituency' do
        expect(assigns(:constituency)).to be_a(Grom::Node)
        expect(assigns(:constituency).type).to eq('https://id.parliament.uk/schema/ConstituencyGroup')
      end

      it 'assigns @asking_person_seat_incumbency' do
        expect(assigns(:asking_person_seat_incumbency)).to be_a(Grom::Node)
        expect(assigns(:asking_person_seat_incumbency).type).to eq('https://id.parliament.uk/schema/SeatIncumbency')
      end

      it 'assigns @answering_person_government_incumbency' do
        expect(assigns(:answering_person_government_incumbency)).to be_a(Grom::Node)
        expect(assigns(:answering_person_government_incumbency).type).to eq('https://id.parliament.uk/schema/GovernmentIncumbency')
      end

      it 'assigns @government_position' do
        expect(assigns(:government_position)).to be_a(Grom::Node)
        expect(assigns(:government_position).type).to eq('https://id.parliament.uk/schema/GovernmentPosition')
      end

      it 'assigns @government_position_name' do
        expect(assigns(:government_position_name)).to be_a(String)
        expect(assigns(:government_position_name)).to eq('positionName - 1')
      end

      it 'assigns @answering_body' do
        expect(assigns(:answering_body)).to be_a(Grom::Node)
        expect(assigns(:answering_body).type).to eq('https://id.parliament.uk/schema/Group')
      end

      it 'assigns @asking_person' do
        expect(assigns(:asking_person)).to be_a(Grom::Node)
        expect(assigns(:asking_person).type).to eq('https://id.parliament.uk/schema/Person')
      end

      it 'assigns @answering_person' do
        expect(assigns(:answering_person)).to be_a(Grom::Node)
        expect(assigns(:answering_person).type).to eq('https://id.parliament.uk/schema/Person')
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end

      context 'if the answering person has no government incumbency' do
        it '@government_position is nil' do
          expect(assigns(:government_position)).to eq(nil)
          expect(assigns(:government_position_name)).to eq(nil)
        end
      end
    end

    context 'with no answer' do
      before(:each) do
        # Question id of question that has not been answered
        get :show, params: { question_id: 'mlhwU1ia' }
      end

      it 'assigns @question' do
        expect(assigns(:question)).to be_a(Grom::Node)
        expect(assigns(:question).type).to eq('https://id.parliament.uk/schema/Question')
      end

      it 'does not assign @answer' do
        expect(assigns(:answer)).to be_empty
      end
    end
  end
end
