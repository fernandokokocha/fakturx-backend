require "rails_helper"

RSpec.describe "Create invoice", type: :request do
  describe 'POST /invoice' do
    let(:params) {
      {
        invoice: {
          number: '001/08/2017',
          date: '30-08-2017',
          month: '08-2017',
          date_of_payment: '10-09-2017',
          items_attributes: [
            {
              name: 'Rzecz',
              net_value: '5000.00',
            }
          ]
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

      it 'creates item' do
        expect{ subject }.to change{ Item.count }.by(1)
      end

      it 'mounts invoice document' do
        subject
        invoice = Invoice.last
        document = invoice.invoice_document
        expect(document.url).to eq("/uploads/invoice/invoice_document/#{invoice.id}/faktura08-2017.pdf")
      end
    end

    context 'happy path - with multiple items' do
      subject do
        new_params = params
        new_params[:invoice][:items_attributes] << { name: 'xyz', net_value: '1000.50' }
        new_params[:invoice][:items_attributes] << { name: 'asdf', net_value: '49.99' }
        post '/invoice', params: new_params
      end

      it 'returns 201' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'creates invoice' do
        expect{ subject }.to change{ Invoice.count }.by(1)
      end

      it 'creates 3 items' do
        expect{ subject }.to change{ Item.count }.by(3)
      end

      it 'mounts invoice document' do
        subject
        invoice = Invoice.last
        document = invoice.invoice_document
        expect(document.url).to eq("/uploads/invoice/invoice_document/#{invoice.id}/faktura08-2017.pdf")
      end
    end

    context 'happy path - with explicit gross amount' do
      subject do
        new_params = params
        new_params[:invoice][:items_attributes].first[:gross_amount] = '9451.55'
        post '/invoice', params: new_params
      end

      it 'returns 201' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'creates invoice' do
        expect{ subject }.to change{ Invoice.count }.by(1)
      end

      it 'overwrites default gross amount' do
        subject
        expect(Invoice.last.items.first.gross_amount).to eq(BigDecimal.new('9451.55'))
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

      it "doesn't create item" do
        expect{ subject }.to_not change{ Item.count }
      end
    end

    [:number, :date, :month, :date_of_payment, :items_attributes].each do |param|
      context "missing #{param}" do
        subject do
          invalid_params = params
          invalid_params[:invoice].delete(param)
          post '/invoice', params: invalid_params
        end

        it 'returns 400' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it "doesn't create invoice" do
          expect{ subject }.to_not change{ Invoice.count }
        end

        it "doesn't create item" do
          expect{ subject }.to_not change{ Item.count }
        end
      end
    end
  end
end
