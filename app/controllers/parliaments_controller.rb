class ParliamentsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:               proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_index },
    show:                proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_by_id.set_url_params({ parliament_id: params[:parliament_id] }) },
    current:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_current },
    next:                proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_next },
    previous:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_previous },
    lookup:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_lookup.set_url_params({ property: params[:source], value: params[:id] }) },
    next_parliament:     proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.next_parliament_by_id.set_url_params({ parliament_id: params[:parliament_id] }) },
    previous_parliament: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.previous_parliament_by_id.set_url_params({ parliament_id: params[:parliament_id] }) }
  }.freeze

  def current
    @parliament = @request.get.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod')).first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def next
    @parliament = @request.get.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod')).first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous
    @parliament = @request.get.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod')).first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def lookup
    @parliament = @request.get.first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def show
    @parliament, @parties = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod'),
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('Party')
    )

    @parliament = @parliament.first
    @parties    = @parties.sort_by(:name)
  end

  def next_parliament
    @parliament = @request.get.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod')).first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous_parliament
    @parliament = @request.get.filter(Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod')).first

    redirect_to parliament_path(@parliament.graph_id)
  end
end
