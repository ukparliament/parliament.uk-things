class HybridBillOrganisationsSubmission < HybridBillBaseSubmission

	attr_accessor :email, :receive_updates, :on_behalf_of

	validates_with HybridBillOrganisationsSubmissionValidator

	#EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates_inclusion_of :receive_updates, :in => [true, false]
	validates :email, :presence => { :message => "Email field cannot be blank if you wish to receive updates" }, :if => :receive_updates
	validates :on_behalf_of, presence: true
	

	# def is_receive_updates_checked?
	# 	unless !receive_updates
	# 		errors[:email]
	# 	end
	# end	
end