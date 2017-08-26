class InvoicesController < ApplicationController
  def create
    if Invoice.create(invoice_params)
      head :created
    else
      head :bad_request
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  private

  def invoice_params
    params.require(:invoice).permit(:number, :date, :month, :date_of_payment)
  end
end
