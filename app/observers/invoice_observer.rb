class InvoiceObserver < ActiveRecord::Observer
  def after_create(invoice)
    rendered_pdf = BuildInvoiceDocument.new.call(invoice)

    s = StringIO.new(rendered_pdf)

    def s.month=(month)
      @month = month
    end

    def s.original_filename
      "faktura#{@month}.pdf"
    end

    s.month = invoice.month
    invoice.invoice_document = s
    invoice.save
  end
end
