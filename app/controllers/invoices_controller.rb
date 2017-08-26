class InvoicesController < ApplicationController
  def create
    invoice = Invoice.new(invoice_params)
    if invoice.save
      return head :created
    else
      return head :bad_request
    end
  rescue ActionController::ParameterMissing
    return head :bad_request
  end

  private

  def invoice_params
    params.require(:invoice).permit(:number, :date, :month, :date_of_payment)
  end
end
