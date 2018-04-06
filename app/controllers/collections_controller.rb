class CollectionsController < ApplicationController
  before_action :data_check, :build_request, :disable_top_navigation

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.collection_by_id.set_url_params({ collection_id: params[:collection_id] }) }
  }.freeze

  def show
    collections = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://example.com/content/schema/Collection'
    )

    # Finds the collection we are looking for, as GET request may return multiple Collections
    @collection = collections.find { |collection| collection.graph_id == params[:collection_id] }
    raise ActionController::RoutingError, 'Collection Not Found' unless @collection
  end
end
