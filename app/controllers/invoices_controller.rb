class InvoicesController < ApplicationController
  def create
    invoice = Invoice.create(invoice_params)
    if invoice.valid?
      head :created
    else
      head :bad_request
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  private

  def invoice_params
    params.require(:invoice).permit(:number, :date, :month, :date_of_payment, items_attributes: [:name, :net_value])
  end
end
