module Parliaments
  class HousesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_house.set_url_params({ parliament_id: params[:parliament_id], house_id: params[:house_id] }) }
    }.freeze

    def show
      @parliament, @house = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', 'House')

      raise ActionController::RoutingError, 'Not Found' if @house.empty?

      @parliament = @parliament.first
      @house      = @house.first
    end
  end
end
