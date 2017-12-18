class PeopleController < ApplicationController
  before_action :data_check, :build_request, except: :postcode_lookup

  ROUTE_MAP = {
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_by_id.set_url_params({ person_id: params[:person_id] }) },
    lookup:            proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_lookup.set_url_params({ property: params[:source], value: params[:id] }) },
  }.freeze

  def show
    # When calculating history, how many years do we want in each block

    @postcode = flash[:postcode]
    @person, @seat_incumbencies, @house_incumbencies, @committee_memberships, @government_incumbencies, @opposition_incumbencies = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'SeatIncumbency', 'HouseIncumbency', 'FormalBodyMembership', 'GovernmentIncumbency', 'OppositionIncumbency')

    @person = @person.first

    @current_party_membership = @person.current_party_membership

    # Only seat incumbencies, not committee roles are being grouped
    incumbencies = GroupingHelper.group(@seat_incumbencies, :constituency, :graph_id)

    roles = []
    roles += incumbencies
    roles += @committee_memberships.to_a if Pugin::Feature::Bandiera.show_committees?
    roles += @house_incumbencies.to_a
    roles += @government_incumbencies.to_a if Pugin::Feature::Bandiera.show_government_roles?
    roles += @opposition_incumbencies.to_a if Pugin::Feature::Bandiera.show_opposition_roles?

    @sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
      list:             @person.incumbencies,
      parameters:       [:end_date],
      prepend_rejected: false
    })

    @most_recent_incumbency = @sorted_incumbencies.last

    @current_incumbency = @most_recent_incumbency && @most_recent_incumbency.current? ? @most_recent_incumbency : nil

    HistoryHelper.reset
    HistoryHelper.add(roles)
    @history = HistoryHelper.history

    @current_roles = @history[:current].reverse!.group_by { |role| Grom::Helper.get_id(role.type) } if @history[:current]

    # !!!!! CODE BELOW THIS POINT ONLY EXECUTES WHEN YOU HAVE CHECKED THAT THIS PERSON IS YOUR MP !!!!!
    return unless @postcode && @current_incumbency

    begin
      response = Parliament::Utils::Helpers::PostcodeHelper.lookup(@postcode)
      @postcode_constituency = response.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ConstituencyGroup')).first
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
