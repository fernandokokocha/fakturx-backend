class Invoice < ApplicationRecord
  validates :number, presence: true
  validates :date, presence: true
  validates :month, presence: true
  validates :date_of_payment, presence: true

  mount_uploader :invoice_document, InvoiceDocumentUploader
end
