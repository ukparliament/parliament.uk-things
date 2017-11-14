class HybridBillBase
  include ActiveModel::Model

  attr_accessor :first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates

  validates :first_name,      presence: true
  validates :surname,         presence: true
  validates :address_1,       presence: true
  validates :email,           presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :telephone,       presence: true
  validates :postcode,        presence: true, format: { with: /\A[a-zA-Z\d\s]{6,9}\z/i }, if: :in_the_uk?
  validates :country,         presence: true
  validates :receive_updates, inclusion: { in: ['1', '0'] }
  validates :in_the_uk,       inclusion: { in: ['true', 'false'] }

  def in_the_uk?
    @country == 'GB'
  end
end
