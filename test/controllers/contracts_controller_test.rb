require "test_helper"
require "errors"

class ContractsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user1 = users(:one)
        @contract1 = contracts(:one)
        @contract2 = contracts(:two)
    end

    test "Should succeed showing a contract" do
        log_in_as(@user1)
        get "/contracts/#{@contract1.id}"
        assert_response :success
        result = response.parsed_body
        assert_equal 'true', result['success']
        assert_equal @contract1.id, result['contract']['id']
    end

    test "Should fail showing a contract that doesn´t belong to a user" do
        log_in_as(@user1)
        get "/contracts/#{@contract2.id}"
        assert_response :success
        result = response.parsed_body
        assert_equal 'false', result['success']
        assert_equal ACCESS_DENIED_ERROR.as_json, result['reason']
    end
end