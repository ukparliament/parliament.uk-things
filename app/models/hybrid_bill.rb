class HybridBill
  attr_accessor :pre_phase_start, :active_phase_start, :post_phase_start, :closed_phase_start

  ## HYBRID_BILLS is defined under #initialize

  class << self
    def find(business_id)
      HybridBill::HYBRID_BILLS&.fetch(business_id.to_s, nil)
    end

    def status(business_id)
      find(business_id)&.status
    end
  end

  def initialize(pre_phase_start, active_phase_start, post_phase_start, closed_phase_start)
    active_after_pre = (active_phase_start > pre_phase_start)
    post_after_active = (post_phase_start > active_phase_start)
    closed_after_post = (closed_phase_start > post_phase_start)

    valid_starts = active_after_pre && post_after_active && closed_after_post

    raise ArgumentError, 'Each phase must occur AFTER the previous phase.' unless valid_starts

    @pre_phase_start    = pre_phase_start
    @active_phase_start = active_phase_start
    @post_phase_start   = post_phase_start
    @closed_phase_start = closed_phase_start
  end

  # Has to go after initialize because it initializes a HybridBill
  HYBRID_BILLS = {
    '1234' => ::HybridBill.new(Time.utc(2017, 12, 1, 12, 0, 0), Time.utc(2018, 1, 6, 9, 0, 0), Time.utc(2020, 1, 1, 9, 0, 0), Time.utc(2020, 1, 2, 9, 0, 0))
  }.freeze

  def status
    time = Time.now.utc

    status = nil
    status = :pre     if pre?(time)
    status = :active  if active?(time)
    status = :post    if post?(time)
    status = :closed  if closed?(time)

    status
  end

  def pre?(time=Time.now.utc)
    time_greater_than?(time, @pre_phase_start) && !time_greater_than?(time, @active_phase_start)
  end

  def active?(time=Time.now.utc)
    time_greater_than?(time, @active_phase_start) && !time_greater_than?(time, @post_phase_start)
  end

  def post?(time=Time.now.utc)
    time_greater_than?(time, @post_phase_start) && !time_greater_than?(time, @closed_phase_start)
  end

  def closed?(time=Time.now.utc)
    time_greater_than?(time, @closed_phase_start)
  end

  private

  def time_greater_than?(time, start)
    time >= start
  end
end
