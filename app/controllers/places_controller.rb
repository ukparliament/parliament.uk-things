class PlacesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.region_by_id.set_url_params({ region_code: params[:place_id] }) },
  }.freeze

  # Renders a single place given a place id.
  # @controller_action_param :region_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion'.

  def show
    @place, @constituencies = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
    @request,
      'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion',
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ConstituencyGroup'),
      ::Grom::Node::BLANK
    )

    @place = @place.first

  end
end
