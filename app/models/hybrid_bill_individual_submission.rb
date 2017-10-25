class HybridBillIndividualSubmission < HybridBillBaseSubmission

	attr_accessor :email, :receive_updates

	validates_with HybridBillIndividualSubmissionValidator

	#EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates_inclusion_of :receive_updates, :in => [true, false]
	validates :email, :presence => { :message => "Email field cannot be blank if you wish to receive updates" }, :if => :receive_updates

	def submitter_type
		1
	end


	# def is_receive_updates_checked?
	# 	unless !receive_updates
	# 		errors[:email]
	# 	end
	# end	
end