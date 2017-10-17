module Parliaments
  class PartiesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      show:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_party.set_url_params({ parliament_id: params[:parliament_id], party_id: params[:party_id] }) }
    }.freeze

    def show
      @parliament, @party = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ParliamentPeriod'),
        Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('Party')
      )

      raise ActionController::RoutingError, 'Not Found' if @party.empty?

      @parliament = @parliament.first
      @party      = @party.first
    end
  end
end
