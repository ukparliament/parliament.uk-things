class HybridBillPetition

	include ActiveModel::Validations

	attr_accessor :committeebusinessid, :address1, :address2, :postcode, :email, :telephone, :firstname, :surname, :has_agent

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :committeebusinessid, presence: true, :numericality => {:only_integer => true, :equal_to => 255}

	validates :accept, :presence => true

	validates :has_agent, inclusion: { in: [true, false] }

	validates :email, :presence => true, :format => { :with => email_regex }



end