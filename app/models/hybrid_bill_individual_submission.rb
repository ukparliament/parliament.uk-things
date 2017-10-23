class HybridBillIndividualSubmission < HybridBillBaseSubmission

	attr_accessor :email, :receive_updates

	validates_with HybridBillIndividualSubmissionValidator

	#EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates_inclusion_of :receive_updates, :in => [true, false]
	validates_presence_of :email, :if => :is_receive_updates_checked?, :message => "email field cannot be blank"

	def is_receive_updates_checked?
		unless !receive_updates
			errors[:email]
		end
	end	
end