class HybridBill

	include ActiveModel::Validations

	attr_accessor :committeebusinessid, :accept, :email

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :committeebusinessid, presence: true, :numericality => {:only_integer => true, :equal_to => 255}

	validates :accept, :presence => true

	validates :email, :presence => true, :format => { :with => email_regex }

end