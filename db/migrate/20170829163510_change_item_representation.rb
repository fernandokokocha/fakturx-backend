class ChangeItemRepresentation < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :net_value, :decimal, precision: 10, scale: 2
    change_column :items, :tax_value, :integer

    remove_column :items, :gross_amount
  end
end
