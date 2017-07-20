module Houses
  class PartiesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      show:    proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]) }
    }.freeze

    def show
      @house, @party = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party'
      )

      @house = @house.first
      @party = @party.first
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)

      raise ActionController::RoutingError, 'Invalid party id' if @party.nil?
    end
  end
end
