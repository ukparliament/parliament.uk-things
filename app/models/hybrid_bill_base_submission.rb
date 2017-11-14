class HybridBillBaseSubmission < HybridBillBase
  attr_accessor :on_behalf_of, :has_a_rep, :hybrid_bill_agent

  validates :has_a_rep,       inclusion: { in: ['true', 'false'] }
end
