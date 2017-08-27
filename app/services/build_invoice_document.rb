class BuildInvoiceDocument
  attr_accessor :pdf, :invoice, :column_width

  def call(invoice)
    @pdf = Prawn::Document.new
    @invoice = invoice
    @column_width = [150, 30, 30, 70, 70, 70]
    @column_width.push(pdf.bounds.right - sum_upto(@column_width, 5))

    set_typography

    pdf.font("open_sans") do
      pdf.font_size(20)

      build_header

      pdf.font_size(10)
      build_sender
      build_recipient
      build_invoice_data
      build_products
    end

    pdf.render
  end

  private

  def set_typography
    fonts = {
      normal: "#{Rails.root.to_s}/app/assets/fonts/OpenSans-Regular.ttf",
      bold: "#{Rails.root.to_s}/app/assets/fonts/OpenSans-Bold.ttf",
      italic: "#{Rails.root.to_s}/app/assets/fonts/OpenSans-Italic.ttf",
      bold_italic: "#{Rails.root.to_s}/app/assets/fonts/OpenSans-BoldItalic.ttf"
    }
    pdf.font_families.update({"open_sans" => fonts})
    pdf.default_leading(5)
  end

  def build_header
    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.move_down(10)
      pdf.text('FAKTURA VAT', align: :center)
      pdf.text(invoice.number, align: :center)
      pdf.stroke_bounds
    end
  end

  def build_sender
    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.move_down(10)
      pdf.indent(20) do
        pdf.text('SPRZEDAWCA:')
        pdf.move_down(10)
        pdf.text(Rails.configuration.invoice['sender']['name'], style: :bold)
        pdf.text(Rails.configuration.invoice['sender']['address'])
        pdf.text(Rails.configuration.invoice['sender']['post_code'])
        pdf.text(Rails.configuration.invoice['sender']['tax_number'])
        pdf.text(Rails.configuration.invoice['sender']['bank_account_number'])
      end
      pdf.move_down(10)
      pdf.stroke_bounds
    end
  end

  def build_recipient
    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.move_down(10)
      pdf.indent(20) do
        pdf.text('NABYWCA:')
        pdf.move_down(10)
        pdf.text(Rails.configuration.invoice['recipient']['name'])
        pdf.text(Rails.configuration.invoice['recipient']['address'])
        pdf.text(Rails.configuration.invoice['recipient']['post_code'])
        pdf.text(Rails.configuration.invoice['recipient']['tax_number'])
      end
      pdf.move_down(10)
      pdf.stroke_bounds
    end
  end

  def build_invoice_data
    build_invoice_data_item('Data wystawienia:', invoice.date.to_s)
    build_invoice_data_item('Miesiąc sprzedaży:', invoice.month.to_s)
    build_invoice_data_item('Sposób płatności:', 'Przelew')
    build_invoice_data_item('Termin płatności:', invoice.date_of_payment.to_s)
  end

  def build_invoice_data_item(name, value)
    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.bounding_box([0, 0], :width => column_width[0]) do
        pdf.move_down(5)
        pdf.indent(20) do
          pdf.text(name, style: :bold)
        end
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + column_width[0], pdf.bounds.top], :width => pdf.bounds.right - column_width[0]) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(value)
        end
        pdf.stroke_bounds
      end
    end
  end

  def build_products
    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.bounding_box([0, 0], :width => column_width[0]) do
        pdf.move_down(5)
        pdf.text('Nazwa towaru / usługi', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 0), pdf.bounds.top], :width => column_width[1]) do
        pdf.move_down(5)
        pdf.text('j.m.', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 1), pdf.bounds.top], :width =>column_width[2]) do
        pdf.move_down(5)
        pdf.text('Ilość', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 2), pdf.bounds.top], :width =>column_width[3]) do
        pdf.move_down(5)
        pdf.text('Cena jedn. netto', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 3), pdf.bounds.top], :width =>column_width[4]) do
        pdf.move_down(5)
        pdf.text('Wartość netto', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 4), pdf.bounds.top], :width =>column_width[5]) do
        pdf.move_down(5)
        pdf.text('Podatek', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 5), pdf.bounds.top], :width =>column_width[6]) do
        pdf.move_down(5)
        pdf.text('Wartość brutto', align: :center)
        pdf.stroke_bounds
      end
    end
  end

  def sum_upto(collection, index)
    collection[0..index].inject(0, :+)
  end
end
