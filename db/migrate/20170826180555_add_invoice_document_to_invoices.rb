class AddInvoiceDocumentToInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :invoice_document, :string
  end
end
