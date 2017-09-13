class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :net_amount, :gross_amount
end
