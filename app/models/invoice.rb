class Invoice < ApplicationRecord
  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items

  validates :items, length: { minimum: 1 }
  validates :number, presence: true
  validates :date, presence: true
  validates :month, presence: true
  validates :date_of_payment, presence: true

  mount_uploader :invoice_document, InvoiceDocumentUploader

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
