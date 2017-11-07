class HybridBillDocument
  include ActiveModel::Model

  attr_accessor :mime_type, :filename, :document_data

  validates :mime_type, presence: true
  validates_format_of :filename, presence: true, with: FILE_TYPE_REGEX
  validates :document_data, presence: true
end
