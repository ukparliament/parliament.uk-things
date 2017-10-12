class HybridBillDocument
  include ActiveModel::Model

  attr_accessor :file, :mime_type, :filename, :filesize

  validates :file, presence: true
  validates_format_of :filename, presence: true, with: /.(doc|DOC|docx|DOCX|rtf|RTF|txt|TXT|ooxml|OOXML|odt|ODT|pdf|PDF)\z/, message: 'unrecognised file'
  validates :filesize, numericality: { only_integer: true, less_than: 2150000 }

  def initialize(attributes)
    super(attributes)

    @mime_type = file.content_type
    @filename  = file.original_filename
    @filesize  = File.size(file.tempfile)
  end
end
