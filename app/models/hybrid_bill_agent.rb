class HybridBillAgent
  include ActiveModel::Model

  attr_accessor :first_name, :surname, :address_1, :address_2, :postcode, :country, :email, :telephone, :receive_updates, :in_the_uk

  validates :first_name, presence: true
  validates :surname, presence: true
  validates :address_1, presence: true
  validates_format_of :email, presence: true, with: EMAIL_REGEX
  validates :telephone, presence: true
  validates_format_of :postcode, presence: true, with: POSTCODE_REGEX, if: :in_the_uk?
  validates :country, presence: true
  validates :receive_updates, inclusion: { in: ['1', '0'] }
  validates :in_the_uk, inclusion: { in: ['true', 'false'] }

  private

  def in_the_uk?
    @country == 'GB'
  end 
  
end
