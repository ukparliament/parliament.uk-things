# Namespace for Business Item Grom::Node helper methods
module BusinessItemHelper
  def self.arrange_by_date(business_items)
    sorted_business_items = sort_by_date(business_items)
    split_by_date(sorted_business_items)
  end

  private

  # Sort business items in reverse chronological order, putting those with no date at the end
  #
  # @return Array of sorted Business Item Grom::Nodes
  def self.sort_by_date(business_items)
    Parliament::NTriple::Utils.sort_by({
      list: business_items,
      parameters: [:date],
      prepend_rejected: true
    })
  end

  # Split business items into past, future and no date
  #
  # @return Three arrays - business items in the past, in the future and those with no date
  def self.split_by_date(business_items)
    business_items_with_no_date = []
    completed_business_items = []
    scheduled_business_items = []

    business_items.each do |business_item|
      business_items_with_no_date << business_item if business_item.date.nil?
      completed_business_items << business_item if business_item.date.present? && business_item.date.past?
      scheduled_business_items << business_item if business_item.date.present? && business_item.date.future?
    end

    return completed_business_items, scheduled_business_items, business_items_with_no_date
  end
end
