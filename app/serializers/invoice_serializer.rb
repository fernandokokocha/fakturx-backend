class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :number, :month, :date

  has_many :items
end
