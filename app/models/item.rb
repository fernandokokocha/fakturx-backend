class Item < ApplicationRecord
  belongs_to :invoice

  def net_amount
    net_value * quantity
  end

  def tax_amount
    (net_amount * tax_value / 100.0).round(2)
  end

  def gross_amount
    net_amount + tax_amount
  end
end
