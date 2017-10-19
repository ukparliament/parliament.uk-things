class HybridBillBaseSubmission
	include ActiveModel::Validations

	attr_accessor :first_name, :last_name, :address_1, :address_2, :postcode, :email, :country, :telephone, :should_be_contacted, :has_agent, :committee_business_id, :county

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :address_1, presence: true
	validates :address_2, presence: true, allow_blank: true
	validates :email, presence: true, allow_blank: true
	validates :telephone, presence: true,  allow_blank: true
	validates :postcode, presence: true
	validates :county, presence: true,  allow_blank: true
	validates_format_of :country, { :with => /[A-Z]{2}/, :message => "Country code is invalid" }
	validates :has_agent, inclusion: { in: [true, false] }
	validates :should_be_contacted, inclusion: { in: [true, false] }
	validates :committee_business_id, presence: true, :numericality => { :only_integer => true, :equal_to => 255 }

	ATTRIBUTE_MAP = {
		first_name: 'FirstName',
		last_name: 'Surname',
		address_1: 'AddressLine1',
		address_2: 'AddressLine2',
		postcode: 'Postcode',
		email: 'Email',
		telephone: 'Telephone',
		should_be_contacted: 'ShouldBeContacted',
		has_agent: 'HasAgent',
		committee_business_id: 'CommitteeBusinessId'
	}
end