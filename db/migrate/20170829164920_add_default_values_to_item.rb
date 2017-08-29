class AddDefaultValuesToItem < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :measure, :string, default: 'szt.'
    change_column :items, :quantity, :integer, default: 1
    change_column :items, :tax_value, :integer, default: 23


    remove_column :items, :gross_value
  end
end
