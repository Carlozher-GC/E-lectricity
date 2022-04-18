require 'constants'

module InvoicesHelper
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
                translated_invoice[INVOICE_KEYS[key]] = value
            end
        end
        translated_invoice
    end
end