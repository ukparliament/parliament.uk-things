class HybridBillBaseSubmission
	include ActiveModel::Validations

	attr_accessor :first_name, :last_name, :address_1, :address_2, :postcode, :country, :telephone, :committee_business_id, :petition_id, :submitter_type
    
    COUNTRY_REGEX = /\A[A-Z]{2}/

	validates :submitter_type, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4 }
	validates :petition_id, presence: true, allow_blank: true
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :address_1, presence: true
	validates :address_2, presence: true, allow_blank: true
	validates :telephone, presence: true,  allow_blank: true
	validates :postcode, presence: true
	validates :country, format: { with: COUNTRY_REGEX, message: "Country code is invalid" }
	validates :committee_business_id, presence: true, numericality: { only_integer: true, equal_to: 255 }

	# ATTRIBUTE_MAP = {
	#   organization_name: 'OnBehalfOf',
	#   submitter_type: 'SubmitterType',
	# 	first_name: 'FirstName',
	# 	last_name: 'Surname',
	# 	address_1: 'AddressLine1',
	# 	address_2: 'AddressLine2',
	# 	postcode: 'Postcode',
	# 	email: 'Email',
	# 	telephone: 'TelephoneNumber',
	# 	receive_updates: 'ReceivesUpdates',
	#   agent: 'HasAgent',
	# 	committee_business_id: 'CommitteeBusinessId'
	# }
end