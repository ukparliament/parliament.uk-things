class ConstituenciesController < ApplicationController
  before_action :data_check, :build_request, except: :postcode_lookup

  ROUTE_MAP = {
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies(params[:constituency_id]) },
    lookup:            proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies.lookup(params[:source], params[:id]) },
    map:               proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies(params[:constituency_id]).map }
  }.freeze

  # Renders a single constituency given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def show
    @postcode = flash[:postcode]

    @constituency, @seat_incumbencies, @party = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency',
      'http://id.ukpds.org/schema/Party'
    )
    # Instance variable for single MP pages
    @single_mp = true
    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)

    @current_incumbency = @seat_incumbencies.shift if !@seat_incumbencies.empty? && @seat_incumbencies.first.current?

    @json_location = constituency_map_path(@constituency.graph_id, format: 'json')

    @party = @party.first

    return if @postcode.nil?

    begin
      response = Parliament::Utils::Helpers::PostcodeHelper.lookup(@postcode)
      @postcode_constituency = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
      postcode_correct = @postcode_constituency.graph_id == @constituency.graph_id
      @postcode_constituency.correct = postcode_correct
    rescue Parliament::Utils::Helpers::PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      @postcode = nil
    end
  end

  # Redirects to a single constituency given an external source and an id that identifies this constituency in that source.
  # @controller_action_param :source [String] external source.
  # @controller_action_param :id [String] external id which identifies a constituency.
  def lookup
    @constituency = @request.get.first

    redirect_to constituency_path(@constituency.graph_id)
  end

  # Post method which accepts form parameters from postcode lookup and redirects to constituency_path.
  # @controller_action_param :postcode [String] postcode entered into postcode lookup form.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  def postcode_lookup
    flash[:postcode] = params[:postcode]

    redirect_to constituency_path(params[:constituency_id])
  end

  # Renders a constituency that has a constituency area object on map view given a constituency id.
  # Will respond with GeoJSON data using the geosparql-to-geojson gem if JSON is requested.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup' which holds a geo polygon.
  # @return [GeosparqlToGeojson::GeoJson] object containing GeoJSON data if JSON is requested.
  def map
    respond_to do |format|
      format.html do
        @constituency = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
          @request,
          'http://id.ukpds.org/schema/ConstituencyGroup'
        ).first

        @json_location = constituency_map_path(@constituency.graph_id, format: 'json')
      end

      format.json do
        @constituency = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
          Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituencies(params[:constituency_id]).map,
          'http://id.ukpds.org/schema/ConstituencyGroup'
        ).first

        raise ActionController::RoutingError, 'Not Found' unless @constituency.current?

        render json: GeosparqlToGeojson.convert_to_geojson(
          geosparql_values:     @constituency.area.polygon,
          geosparql_properties: {
            name:       @constituency.name,
            start_date: @constituency.start_date,
            end_date:   @constituency.end_date
          },
          reverse: false
        ).geojson
      end
    end
  end
end
