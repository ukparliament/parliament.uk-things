class HybridBillBaseSubmission
	include ActiveModel::Validations

	attr_accessor :on_behalf_of, :first_name, :last_name, :address_1, :address_2, :postcode, :country, :telephone, :receive_updates

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :address_1, presence: true
	validates :email, presence: true
	validates :telephone, presence: true
	validates :postcode, presence: true
	validates :country, presence: true
	validates :receive_updates, inclusion: { in: [true, false] }
end