class HousesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:               proc  { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_by_id.set_url_params({ house_id: params[:house_id] }) },
    lookup:             proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_lookup.set_url_params({ property: params[:source], value: params[:id] }) },
  }.freeze

  def show
    @house = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House').first
  end

  def lookup
    @house = @request.get.first

    redirect_to house_path(@house.graph_id)
  end
end
