class AddGrossAmountToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :gross_amount, :decimal, precision: 10, scale: 2
  end
end
