require "rails_helper"

RSpec.describe "Index invoices", :type => :request do
  subject do
    get '/invoice'
  end

  context 'happy path - no invoices' do
    it 'returns 200' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'renders json document' do
      subject
      expect(response.content_type).to eq('application/json')
    end
  end

  context 'happy path - one invoice' do
    before(:each) do
      FactoryGirl.create(:invoice)
    end

    it 'returns 200' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'renders json document' do
      subject
      expect(response.content_type).to eq('application/json')
    end

    it 'renders one invoice' do
      subject
      expect(JSON.parse(response.body).length).to eq(1)
    end

    ['id', 'number', 'month', 'date'].each do |attr|
      it "renders invoice with #{attr} attribute" do
        subject
        invoice = JSON.parse(response.body).first
        expect(invoice[attr]).to be_truthy
      end
    end

    ['id', 'name', 'net_amount', 'gross_amount'].each do |attr|
      it "renders invoice item with #{attr} attribute" do
        subject
        item = JSON.parse(response.body).first['items'].first
        expect(item[attr]).to be_truthy
      end
    end
  end
end
