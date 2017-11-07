class HybridBillBaseSubmission
  include ActiveModel::Model

	attr_accessor :on_behalf_of, :first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates, :has_a_rep, :hybrid_bill_agent

	validates :first_name,      presence: true
	validates :surname,         presence: true
	validates :address_1,       presence: true
	validates :email,           presence: true
	validates :telephone,       presence: true
	validates :postcode,        presence: true
	validates :country,         presence: true
	validates :receive_updates, inclusion: { in: ['1', '0'] }
  validates :in_the_uk,       inclusion: { in: ['true', 'false'] }
  validates :has_a_rep,       inclusion: { in: ['true', 'false'] }
end
