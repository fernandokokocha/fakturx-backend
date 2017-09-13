FactoryGirl.define do
  factory :invoice do
    number '001/08/2017'
    date Time.now
    month '08/2017'
    date_of_payment Time.now + 1.month

    transient do
      items_count 1
    end

    after :build do |invoice, evaluator|
      invoice.items << FactoryGirl.build_list(:item, evaluator.items_count, invoice: nil)
    end
  end
end
