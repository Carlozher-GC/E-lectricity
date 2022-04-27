class Invoice < ApplicationRecord
    belongs_to :user

    validate :invoice_number_unique?

    # Check that the user hasn´t already uploaded the invoice
    def invoice_number_unique?
        if Invoice.find_by(invoice_number: invoice_number).present?
            errors.add(:invoice_number,
                       :invoice_repeated,
                       message: 'This invoice has already been uploaded')
        end
    end
end
