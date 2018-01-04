module HistoryHelper
  # Builds a history object, separating and sorting data into time periods
  include Parliament::NTriple::Utils

  # Returns year_separator variable (getter method)
  #
  # @return [Integer] Number of years used to divide up the timeline into time periods
  def self.year_separator
    @year_separator ||= 10
  end

  # Assigns year_separator variable if not already set (setter method)
  #
  # @param number [Integer] Number of years to divide up the timeline by, in order to create time periods
  # @return [Integer] Number of years used to divide up the timeline into time periods
  def self.year_separator=(number)
    @year_separator = number
  end

  # Creates/sets an empty history object
  #
  # @return [Hash] Object with properties of start, current and years
  def self.history
    @history ||= {
      start:   nil,
      current: [],
      # Keys are the time periods
      # Value is array of Grom::Nodes that have occured during this time period
      years:   {}
    }
  end

  # Resets history
  #
  # @return [nil] Resets history to nil
  def self.reset
    @history = nil
  end

  # Adds data to history object, separating current Grom::Nodes from historic Grom::Nodes
  # and setting start date of earliest Grom::Node
  #
  # @param data [Array] Array of Grom::Nodes
  # @return [Hash] History object with Grom::Nodes divided into historic and current
  def self.add(data)
    return if data.nil? || data.empty?
    # Set history if it has not already been set
    history
    data.each do |entry|
      # Current
      @history[:current] << entry if entry.try(:end_date).nil?

      # Exit if there is no end date or if the end date is not a date
      next if entry.try(:end_date).try(:year).try(:to_f).nil?

      # e.g. If current year is 2017, end date is 2008 and year_separator is 10...
      # year = ((2017-2008)/10).ceil) * 10 = 0
      # But as it happened within the last 10 years, we want it to be placed in the 10 year time period, not 0
      year = ((Time.now.year.to_f - entry.end_date.year.to_f) / year_separator).ceil * year_separator
      year = year_separator if year == 0

      @history[:years][year] = [] unless @history[:years][year]
      @history[:years][year] << entry

      if entry.respond_to?(:start_date)
        @history[:start] = entry.start_date if @history[:start].nil? || @history[:start] > entry.start_date
      end
    end

    # Sort current Grom::Nodes by start date
    @history[:current].sort_by!(&:start_date).reverse!
    sort_history
  end

  # Sorts Grom::Nodes first by end date, then by start date (if same end date)
  #
  # @return [Hash] History object with divided and sorted Grom::Nodes
  def self.sort_history
    @history[:years].keys.each do |year|
      @history[:years][year] = Parliament::NTriple::Utils.multi_direction_sort(
        {
          list:       @history[:years][year],
          parameters: { end_date: :desc, start_date: :desc }
        }
      )
    end
  end
end
