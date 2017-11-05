class AddStateToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :state, :string
  end
end
