class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :number, :date, :url, :gross_sum

  has_many :items
end
