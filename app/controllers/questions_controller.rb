class QuestionsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.question_by_id.set_url_params({ question_id: params[:question_id] }) }
  }.freeze

  def show
    @question, @answer = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Question', 'Answer')
    @question = @question.first
    @asking_person = @question.asking_person
    @asking_person_seat_incumbency = @asking_person.seat_incumbencies.first
    @constituency = @asking_person_seat_incumbency.constituency
    @answering_body = @question.answering_body_allocation.answering_body if @question.answering_body_allocation.present?

    return unless @answer.present?
    @answer = @answer.first
    @answer_text = AnswerHelper.add_url_class_to_anchors(@answer.text.dup)
    @answering_person = @answer.answering_person
    @answering_person_government_incumbency = @answering_person.government_incumbencies.first
    @government_position = @answering_person_government_incumbency.government_position
  end
end
