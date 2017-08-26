require "rails_helper"

RSpec.describe "Invoice requests", :type => :request do
  describe 'POST /invoice' do
    let(:params) {
      {
        invoice: {
          number: 'abc',
          date: '30-08-2017',
          month: '08-2017',
          date_of_payment: '10-09-2017',
        }
      }
    }

    subject do
      post '/invoice', params: params
    end

    context 'happy path' do
      it 'returns 201' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'creates invoice' do
        expect{ subject }.to change{ Invoice.count }.by(1)
      end
    end

    context 'params without invoice wrapper' do
      let(:params) {
        {
          number: 'abc',
          date: '30-08-2017',
          month: '08-2017',
          date_of_payment: '10-09-2017',
        }
      }

      it 'returns 400' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it "doesn't create invoice" do
        expect{ subject }.to_not change{ Invoice.count }
      end
    end

    [:number, :date, :month, :date_of_payment].each do |param|
      context "missing #{param}" do
        let(:invalid_params) { params[:invoice].delete(param) }

        subject do
          post '/invoice', params: invalid_params
        end

        it 'returns 400' do
          subject
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
