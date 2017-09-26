class Item < ApplicationRecord
  belongs_to :invoice

  before_save :calc_gross_amount_if_missing

  def net_amount
    net_value * quantity
  end

  def tax_amount
    (net_amount * tax_value / 100.0).round(2)
  end

  def calc_gross_amount_if_missing
    return if self.gross_amount
    self.gross_amount = net_amount + tax_amount
  end
end
