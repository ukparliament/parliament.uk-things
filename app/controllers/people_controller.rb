class PeopleController < ApplicationController
  before_action :data_check, :build_request, except: :postcode_lookup

  ROUTE_MAP = {
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_by_id.set_url_params({ person_id: params[:person_id] }) },
    lookup:            proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_lookup.set_url_params({ property: params[:source], value: params[:id] }) },
  }.freeze

  def show
    @postcode = flash[:postcode]

    @person, @seat_incumbencies, @house_incumbencies, @committees = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/SeatIncumbency',
      'http://id.ukpds.org/schema/HouseIncumbency',
      'http://id.ukpds.org/schema/FormalBody'
    )

    @person = @person.first

    @current_party_membership = @person.current_party_membership

    sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
      list:             @person.incumbencies,
      parameters:       [:end_date],
      prepend_rejected: false
    })

    @most_recent_incumbency = sorted_incumbencies.last
    @current_incumbency = @most_recent_incumbency && @most_recent_incumbency.current? ? @most_recent_incumbency : nil

    return unless @postcode && @current_incumbency

    begin
      response = Parliament::Utils::Helpers::PostcodeHelper.lookup(@postcode)
      @postcode_constituency = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
      postcode_correct = @postcode_constituency.graph_id == @current_incumbency.constituency.graph_id
      @postcode_constituency.correct = postcode_correct
    rescue Parliament::Utils::Helpers::PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      @postcode = nil
    end
  end

  def lookup
    @person = @request.get.first

    redirect_to person_path(@person.graph_id)
  end

  def postcode_lookup
    flash[:postcode] = params[:postcode]

    redirect_to person_path(params[:person_id])
  end
end
