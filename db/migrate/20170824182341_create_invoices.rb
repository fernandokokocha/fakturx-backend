class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :number
      t.date :date
      t.string :month
      t.date :date_of_payment

      t.timestamps
    end
  end
end
