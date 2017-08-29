class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :measure
      t.integer :quantity
      t.string :net_value
      t.string :tax_value
      t.string :gross_value
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
