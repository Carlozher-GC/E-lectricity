require 'constants'

module InvoicesHelper
    def read_invoice
        if is_json?(params[:invoice].original_filename)
            translate_invoice(parse_invoice(params[:invoice]))
        end
    end

    def is_json?(filename)
        extension = filename[(filename.index('.')), filename.length]
        extension == '.json'
    end

    # Converts the invoice read from a file to a Ruby Hash
    def parse_invoice(invoice)
        JSON.parse(invoice.read).transform_keys(&:to_sym)
    end

    # Translate the invoice keys to human readable keys
    def translate_invoice(invoice)
        translated_invoice = {}
        invoice.each do |key, value|
            if INVOICE_KEYS.has_key?(key)
                if INVOICE_FIELDS_BY_TYPE[:date].include?(INVOICE_KEYS[key])
                    translated_invoice[INVOICE_KEYS[key]] = parse_date(value)
                else
                    translated_invoice[INVOICE_KEYS[key]] = value
                end
            end
        end
        translated_invoice
    end

    def parse_date(date)
        dd_mm_yy = date.split(' de ')
        return date if dd_mm_yy.length != 3

        Date.new(dd_mm_yy[2].to_i, get_month(dd_mm_yy[1].downcase.to_sym), dd_mm_yy[0].to_i)
    end

    def get_month(month)
        MONTHS[month]
    end

    def calculate_field_average(invoices, field)
        (invoices.sum(0.0) { |invoice| invoice[field] })/invoices.length
    end
end