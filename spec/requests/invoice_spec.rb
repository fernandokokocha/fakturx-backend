require "rails_helper"

RSpec.describe "Invoice requests", :type => :request do
  describe 'POST /invoice' do
    let(:params) {
      { invoice: { number: 'abc' } }
    }

    context 'happy path' do
      it 'returns 201' do
        post '/invoice', params: params
        expect(response).to have_http_status(:created)
      end
    end

    context 'missing number' do
      it 'returns 400' do
        invalid_params = params
        invalid_params[:invoice].delete(:number)
        post '/invoice', params: invalid_params
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
