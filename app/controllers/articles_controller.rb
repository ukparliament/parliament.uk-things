class ArticlesController < ApplicationController
  before_action :data_check, :build_request, :disable_top_navigation

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.webarticle_by_id.set_url_params({ webarticle_id: params[:article_id] }) }
  }.freeze

  def show
    articles = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'WebArticle')

    # Finds the article we are looking for, as GET request may return multiple Articles
    @article = articles.find { |article| article.graph_id == params[:article_id] }
    raise ActionController::RoutingError, 'Article Not Found' unless @article

    @collections = @article.collections

    # Gathers the root collections for the collections which the article appears in
    @root_collections = @article.collections.map(&:orphaned_ancestors).flatten
  end
end
