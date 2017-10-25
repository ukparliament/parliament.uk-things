class HybridBillPetitionAgent < HybridBillBaseSubmission

	include ActiveModel::Validations

	attr_accessor :email, :receive_updates

	validates_with HybridBillPetitionAgentValidator

	#EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates_inclusion_of :receive_updates, :in => [true, false]
	validates :email, :presence => { :message => "Email field cannot be blank if you wish to receive updates" }, :if => :receive_updates


end