require "test_helper"

class ContractTest < ActiveSupport::TestCase
  def setup
    @contract1 = contracts(:one)
    @contract2 = contracts(:two)
  end

  test "Should fail saving a contract with a repeated name for a same user" do
    @contract2.user_id = 1
    @contract2.name = 'one'
    assert_not @contract2.save
  end
end
