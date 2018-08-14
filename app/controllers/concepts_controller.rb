class ConceptsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.concept_by_id.set_url_params({ concept_id: params[:concept_id] }) }
  }.freeze

  def show
    concepts = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Concept')

    # Finds the concept we are looking for, as GET request may return multiple Concepts
    @concept = concepts.find { |concept| concept.graph_id == params[:concept_id] }
    raise ActionController::RoutingError, 'Concept Not Found' unless @concept

    # Returns array of Concept Grom::Nodes
    @narrower_concepts = @concept.narrower_concepts.sort_by(&:name)
    @concept_articles = @concept.tagged_articles.sort_by(&:article_title)

  end

end
