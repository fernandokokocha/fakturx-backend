i = Invoice.new(
  number: '001/02/2017',
  date: '31-01-2017',
  month: '02-2017',
  date_of_payment: '10-02-2017'
)

i.items << Item.new(
  name: 'Test',
  net_value: '5000.00'
)

i.save
