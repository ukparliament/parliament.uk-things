require 'rails_helper'

RSpec.describe 'questions/show', vcr: true do
  context 'Question has been answered' do
    before do
      assign(:question,
        double(:question,
          asked_at_date: Date.parse('24 Nov 2017'),
          text: 'Question text1',
          heading: 'Question heading1'))

      assign(:asking_person,
        double(:asking_person,
          full_name: 'Name1 Name2',
          image_id: '6789101',
          graph_id: 'hfFS7SEH'))

      assign(:answering_person,
        double(:answering_person,
          full_name: 'Name3 Name4',
          image_id: '1357910',
          graph_id: 'j3tFA6NO'))

      assign(:constituency,
        double(:constituency,
          name: 'Kingston upon Thames'))

      assign(:answering_body,
        double(:answering_body,
          name: 'Department of Health'))

      assign(:answer,
        double(:answer,
          text: 'Answer text1',
          answer_given_date: Date.parse('25 Dec 2017')))

      assign(:answer_text, 'Answer text1')

      assign(:answering_person_government_incumbency,
        double(:answering_person_government_incumbency,
        current?:  false,
        end_date:  Date.parse('24 Jan 2018')))

      assign(:asking_person_seat_incumbency,
        double(:asking_person_seat_incumbency,
        current?:  false,
        end_date:  Date.parse('24 Feb 2018'),
        house_of_lords?: false))

      assign(:government_position,
        double(:government_position,
          name: 'Minister'))
          render
      end

    context 'question' do
      it 'will render the correct question text' do
        expect(rendered).to match(/Question text1/)
      end

      it 'will render the correct question heading' do
        expect(rendered).to match(/Question heading1/)
      end

      it 'will render the correct question asked at date' do
        expect(rendered).to match(/Asked on 24 November 2017 by/)
      end
    end

    context 'asking_person_seat_incumbency' do
      it 'will render the correct asking person incumbency end date' do
        expect(rendered).to match(/until 24 February 2018/)
      end

      context 'asking person is an MP' do
        it 'will render the correct asking person house' do
          expect(rendered).to match(/MP for/)
        end
      end

      context 'asking person is a lord' do
        before do
          assign(:asking_person_seat_incumbency,
            double(:asking_person_seat_incumbency,
            current?:  false,
            end_date:  Date.parse('24 Feb 2018'),
            house_of_lords?: true))
            render
        end

        it 'will render the correct asking person house' do
          expect(rendered).to match(/Member of the House of Lords/)
        end
      end
    end

    context 'constituency' do
      it 'will render the correct asking person constituency' do
        expect(rendered).to match(/Kingston upon Thames/)
      end
    end

    context 'answering_body' do
      it 'will render the correct answering body' do
        expect(rendered).to match(/For Department of Health/)
      end
    end

    context 'answer' do
      it 'will render the correct answer text' do
        expect(rendered).to match(/Answer text1/)
      end

      it 'will render the correct answer given date' do
        expect(rendered).to match(/Answered on 25 December 2017 by/)
      end
    end

    context 'answering_person' do
      it 'will render the correct answering person full name' do
        expect(rendered).to match(/Name3 Name4/)
      end

      it 'will render the correct answering person graph id' do
        expect(rendered).to match(/j3tFA6NO/)
      end

      it 'will render the correct answering person image id' do
        expect(rendered).to match(/1357910/)
      end
    end

    context 'government_position' do
      it 'will render the correct government position' do
        expect(rendered).to match(/Minister/)
      end
    end

    context 'answering_person_government_incumbency' do
      it 'will render the correct answering person government incumbency end date' do
        expect(rendered).to match(/until 24 January 2018/)
      end
    end
  end



  context 'Question has not been answered' do
    before do
      assign(:question,
        double(:question,
          uin: '123456',
          asked_at_date: Date.parse('24 Nov 2017'),
          text: 'Question text1',
          heading: 'Question heading1'))

      assign(:asking_person,
        double(:asking_person,
          full_name: 'Name1 Name2',
          image_id: '6789101',
          graph_id: 'hfFS7SEH'))

      assign(:constituency,
        double(:constituency,
          name: 'Kingston upon Thames'))

      assign(:answering_body,
        double(:answering_body,
          name: 'Department of Health'))

      assign(:asking_person_seat_incumbency,
        double(:asking_person_seat_incumbency,
        current?:  false,
        end_date:  Date.parse('24 Feb 2018'),
        house_of_lords?: false))

        render
      end

    context 'answer' do
      it 'will not render the answer text' do
        expect(rendered).not_to match(/Answer text1/)
      end

      it 'will render not yet answered' do
        expect(rendered).to match(/Not yet answered/)
      end
    end
  end
end
