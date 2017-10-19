require "rails_helper"

RSpec.describe "Index invoices", acceptance: true do
  let(:invoice1_description) { 'Single short item' }
  let(:invoice1_url) {
    i = Invoice.new(
      number: '001/02/2017',
      date: '31-01-2017',
      month: '02-2017',
      date_of_payment: '10-02-2017',
    )

    i.items.build(
      name: 'Test',
      net_value: '5000.00'
    )

    i.save
    i.url
  }

  let(:invoice2_description) { 'Three items' }
  let(:invoice2_url) {
    i = Invoice.new(
      number: '001/05/2017',
      date: '31-05-2017',
      month: '05-2017',
      date_of_payment: '10-06-2017',
    )

    i.items.build(
      name: 'Service 1',
      net_value: '1000.41'
    )

    i.items.build(
      name: 'Service 2',
      net_value: '3000.99'
    )

    i.items.build(
      name: "Now that's a super service, number 3",
      net_value: '100001.50'
    )

    i.save
    i.url
  }

  let(:invoice3_description) { 'Two items, one with long description' }
  let(:invoice3_url) {
    i = Invoice.new(
      number: '001/05/2017',
      date: '31-05-2017',
      month: '05-2017',
      date_of_payment: '10-06-2017',
    )

    i.items.build(
      name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore",
      net_value: '9988.99'
    )

    i.items.build(
      name: "That's a short one",
      net_value: '1000.00'
    )

    i.save
    i.url
  }

  context 'single short item' do
    let(:invoices) {
      [
        [invoice1_description, invoice1_url],
        [invoice2_description, invoice2_url],
        [invoice3_description, invoice3_url],
      ]
    }

    it 'works' do
      puts
      puts 'Please verify following generated documents on your own'
      invoices.each do |desc, url|
        puts
        puts "#{desc}:"
        puts "file://#{url}"
      end
    end
  end
end
