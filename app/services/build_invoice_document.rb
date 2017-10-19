require 'slownie'

class BuildInvoiceDocument
  attr_accessor :pdf, :invoice, :column_width, :date_format

  def call(invoice)
    @pdf = Prawn::Document.new
    @invoice = invoice
    @column_width = [150, 30, 30, 80, 80, 20, 60]
    @column_width.push(pdf.bounds.right - sum_upto(@column_width, 6))

    @date_format = '%d.%m.%y'

    set_typography

    pdf.font("open_sans") do
      pdf.font_size(20)

      build_header

      pdf.font_size(10)
      build_sender
      build_recipient
      build_invoice_data
      build_products_header
      invoice.items.each do |item|
        build_product(item)
      end
      build_total_amounts

      pdf.font_size(12)
      build_summary
      build_annotation
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
    build_invoice_data_item('Data wystawienia:', invoice.date.strftime(date_format))
    build_invoice_data_item('Miesiąc sprzedaży:', invoice.month)
    build_invoice_data_item('Sposób płatności:', 'Przelew')
    build_invoice_data_item('Termin płatności:', invoice.date_of_payment.strftime(date_format))
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

  def build_products_header
    height = 40

    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.bounding_box([0, 0], width: column_width[0], height: height) do
        pdf.move_down(10)
        pdf.text('Nazwa towaru / usługi', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 0), pdf.bounds.top], width: column_width[1], height: height) do
        pdf.move_down(10)
        pdf.text('j.m.', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 1), pdf.bounds.top], width: column_width[2], height: height) do
        pdf.move_down(10)
        pdf.text('Ilość', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 2), pdf.bounds.top], width: column_width[3], height: height) do
        pdf.move_down(10)
        pdf.text('Cena jedn. netto', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 3), pdf.bounds.top], width: column_width[4], height: height) do
        pdf.move_down(10)
        pdf.text('Wartość netto', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 4), pdf.bounds.top], width: column_width[5] + column_width[6], height: height/2) do
        pdf.move_down(5)
        pdf.text('Podatek', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 4), pdf.bounds.top - height/2], width: column_width[5], height: height/2) do
        pdf.move_down(5)
        pdf.text('%', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 5), pdf.bounds.top - height/2], width: column_width[6], height: height/2) do
        pdf.move_down(5)
        pdf.text('Kwota', align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 6), pdf.bounds.top], width: column_width[7], height: height) do
        pdf.move_down(10)
        pdf.text('Wartość brutto', align: :center)
        pdf.stroke_bounds
      end
    end
  end

  def build_product(item)
    rows = (item.name.length / 30.0).ceil
    height = 20 * rows

    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.bounding_box([0, 0], width: column_width[0], height: height) do
        pdf.move_down(5)
        pdf.text(item.name, align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 0), pdf.bounds.top], width: column_width[1], height: height) do
        pdf.move_down(5)
        pdf.text(item.measure, align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 1), pdf.bounds.top], width: column_width[2], height: height) do
        pdf.move_down(5)
        pdf.text(item.quantity.to_s, align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 2), pdf.bounds.top], width: column_width[3], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(item.net_value), align: :left)
        end
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 3), pdf.bounds.top], width: column_width[4], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(item.net_amount), align: :left)
        end
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 4), pdf.bounds.top], width: column_width[5], height: height) do
        pdf.move_down(5)
        pdf.text(item.tax_value.to_s, align: :center)
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 5), pdf.bounds.top], width: column_width[6], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(item.tax_amount), align: :left)
        end
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.left + sum_upto(column_width, 6), pdf.bounds.top], width: column_width[7], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(item.gross_amount), align: :left)
        end
        pdf.stroke_bounds
      end
    end
  end

  def build_total_amounts
    height = 20

    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.bounding_box([sum_upto(column_width, 2), pdf.bounds.top], width: column_width[3], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text("RAZEM", align: :left, style: :bold)
        end
      end

      pdf.bounding_box([sum_upto(column_width, 3), pdf.bounds.top], width: column_width[4], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(invoice.net_sum), align: :left, style: :bold)
        end
        pdf.stroke_bounds
      end

      pdf.bounding_box([sum_upto(column_width, 4), pdf.bounds.top], width: column_width[5], height: height) do
        pdf.move_down(5)
        pdf.text("X", align: :center, style: :bold)
        pdf.stroke_bounds
      end

      pdf.bounding_box([sum_upto(column_width, 5), pdf.bounds.top], width: column_width[6], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(invoice.tax_sum), align: :left, style: :bold)
        end
        pdf.stroke_bounds
      end

      pdf.bounding_box([sum_upto(column_width, 6), pdf.bounds.top], width: column_width[7], height: height) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(format_money(invoice.gross_sum), align: :left, style: :bold)
        end
        pdf.stroke_bounds
      end
    end
  end

  def build_summary
    pdf.move_down(40)
    build_summary_item('Do zapłaty:', "#{format_money(invoice.gross_sum)} zł")
    pdf.move_down(10)
    build_summary_item('Słownie:', "#{zloty_slownie_from_value(invoice.gross_sum)} #{groszy_slownie_from_value(invoice.gross_sum)}")
  end

  def build_summary_item(name, value)
    pdf.bounding_box([0, pdf.cursor], :width => pdf.bounds.right) do
      pdf.bounding_box([0, 0], :width => column_width[0]) do
        pdf.move_down(5)
        pdf.indent(20) do
          pdf.text(name, style: :bold)
        end
      end

      pdf.bounding_box([pdf.bounds.left + column_width[0], pdf.bounds.top], :width => pdf.bounds.right - column_width[0]) do
        pdf.move_down(5)
        pdf.indent(10) do
          pdf.text(value)
        end
      end
    end
  end

  def build_annotation
    pdf.move_down(50)
    pdf.text('Faktura nie wymaga podpisu.', style: :italic)
  end

  def sum_upto(collection, index)
    collection[0..index].inject(0, :+)
  end

  def zloty_slownie_from_value(value)
    Slownie.slownie(value.truncate).capitalize
  end

  def groszy_slownie_from_value(value)
    grosze = ((value - (value.truncate)) * 100.0).truncate
    return 'zero groszy' if (grosze.to_s === '0')
    Slownie.slownie(grosze)
      .gsub('złotych', 'groszy')
      .gsub('złoty', 'grosz')
      .gsub('złote', 'grosze')
  end

  def format_money(value)
    "#{"%.2f" % value}"
  end
end
