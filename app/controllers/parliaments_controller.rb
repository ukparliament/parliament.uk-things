class ParliamentsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:                proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]) },
    current:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments.current },
    next:                proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments.next },
    previous:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments.previous },
    lookup:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments.lookup(params[:source], params[:id]) },
    next_parliament:     proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).next },
    previous_parliament: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).previous }
  }.freeze

  def current
    @parliament = @request.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def next
    @parliament = @request.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous
    @parliament = @request.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def lookup
    @parliament = @request.get.first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def show
    @parliament, @parties = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Party'
    )

    @parliament = @parliament.first
    @parties    = @parties.sort_by(:name)
  end

  def next_parliament
    @parliament = @request.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous_parliament
    @parliament = @request.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end
end
