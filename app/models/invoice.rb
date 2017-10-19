class Invoice < ApplicationRecord
  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items

  validates :items, length: { minimum: 1 }
  validates :number, presence: true
  validates :date, presence: true
  validates :month, presence: true
  validates :date_of_payment, presence: true

  mount_uploader :invoice_document, InvoiceDocumentUploader

  after_create :create_document

  def create_document
    rendered_pdf = BuildInvoiceDocument.new.call(self)

    s = StringIO.new(rendered_pdf)

    def s.month=(month)
      @month = month
    end

    def s.original_filename
      "faktura#{@month}.pdf"
    end

    s.month = self.month
    self.invoice_document = s
    self.save
  end

  def net_sum
    items.inject(0) do |result, item|
      result += item.net_amount
    end
  end

  def tax_sum
    items.inject(0) do |result, item|
      result += item.tax_amount
    end
  end

  def gross_sum
    items.inject(0) do |result, item|
      result += item.gross_amount
    end
  end

  def url
    self.invoice_document.path
  end
end
