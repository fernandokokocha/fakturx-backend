require "rails_helper"

RSpec.describe "Invoice requests", :type => :request do
  describe 'POST /invoice' do
    it 'returns 201' do
      post '/invoice'
      expect(response).to have_http_status(:created)
    end
  end
end
