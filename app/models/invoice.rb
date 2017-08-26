class Invoice < ApplicationRecord
  validates :number, presence: true
  validates :date, presence: true
  validates :month, presence: true
  validates :date_of_payment, presence: true

  mount_uploader :invoice_document, InvoiceDocumentUploader

  after_validation :create_document

  def create_document
    pdf = Prawn::Document.new
    pdf.text('Hello World')

    s = StringIO.new(pdf.render)

    def s.month=(month)
      @month = month
    end

    def s.original_filename
      "faktura#{@month}.pdf"
    end

    s.month = self.month
    self.invoice_document = s
  end
end
