require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  def setup
    @invoice1 = invoices(:one)
    @invoice2 = invoices(:two)
  end

  test "Should fail saving an invoice with a repeated invoice_number for a same contract" do
    @invoice2.contract_id = 1
    @invoice2.invoice_number = 'one'
    assert_not @invoice2.save
    assert @invoice2.errors.include?(:invoice_number)
  end
end
