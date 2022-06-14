class Invoice < ApplicationRecord
    belongs_to :contract

    validate :invoice_number_unique?

    # Check that the user hasn´t already uploaded the invoice for the same contract
    def invoice_number_unique?
        if contract.invoices.find_by(invoice_number: invoice_number).present?
            errors.add(:invoice_number,
                       :invoice_repeated,
                       message: 'This invoice has already been uploaded')
        end
    end
    # TODO: validate that a user can´t have more than one invoice for the same month of the same year
end
