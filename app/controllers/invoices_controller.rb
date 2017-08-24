class InvoicesController < ApplicationController
  def create
    Invoice.create(invoice_params)
    head :created
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  private

  def invoice_params
    params.require(:invoice).permit(:number)
  end
end
