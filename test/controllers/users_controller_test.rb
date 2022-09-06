require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user1 = users(:one)
        @user2 = users(:two)
    end

    test 'Should show user without including password' do
        log_in_as(@user1)
        get "/user/#{@user1.id}"
        assert_response :success
        user = response.parsed_body
        assert_equal @user1.username, user['username']
        assert response['encrypted_password'].blank?
    end

    test 'Show user should fail if user is disabled' do
        log_in_as(@user2)
        get "/user/#{@user2.id}"
        assert_response :redirect
    end

    test 'current_user should return the logged user information' do
        log_in_as(@user1)
        get "/current_user"
        assert_response :success
        user = response.parsed_body
        assert_equal @user1.username, user['username']
        assert response['encrypted_password'].blank?
    end
end