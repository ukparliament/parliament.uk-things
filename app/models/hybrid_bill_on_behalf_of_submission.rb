class HybridBillOnBehalfOfSubmission < HybridBillBaseSubmission
	validates :on_behalf_of, presence: true
end