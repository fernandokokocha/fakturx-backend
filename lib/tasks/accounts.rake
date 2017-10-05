namespace :accounts do
  desc "Create new invoice"
  task create_invoice: :environment do
    i = Invoice.new(
      number: '001/09/2017',
      date: '30.09.2017',
      month: '09.2017',
      date_of_payment: '10.10.2017'
    )

    i.items << Item.new(
      name: "Świadczenie usług\nprogramistycznych",
      net_value: '1000.00'
    )

    i.items << Item.new(
      name: 'Godziny nadliczbowe - wrzesień',
      net_value: '500.00'
    )

    i.save

    puts 'Invoice created. See: ' + i.url
  end

end
