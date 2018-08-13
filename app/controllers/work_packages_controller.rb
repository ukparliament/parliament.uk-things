class WorkPackagesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.work_package_by_id.set_url_params({ work_package_id: params[:work_package_id] }) }
  }.freeze

  # @return [Grom::Node] object with type 'https://id.parliament.uk/schema/WorkPackage'.
  def show
    @work_package, @work_packageable_thing, @procedure, @business_items = Parliament::Utils::Helpers::FilterHelper.filter(
      @request,
      'WorkPackage',
      'WorkPackageableThing',
      'Procedure',
      'BusinessItem'
    )

    @work_packageable_thing = @work_packageable_thing.first
    @work_package = @work_package.first
    @procedure = @procedure.first

    @completed_business_items, @scheduled_business_items, @business_items_with_no_date = BusinessItemHelper.arrange_by_date(@business_items.nodes)

    # Group completed business items by their date
    @completed_business_items = Parliament::Utils::Helpers::BusinessItemGroupingHelper.group(@completed_business_items, :date)
  end
end
