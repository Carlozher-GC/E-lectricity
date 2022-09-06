require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:one)
    @user2 = users(:two)
  end

  test "Should fail saving user with an existing email" do
    assert_equal @user1.email, 'uno@email.com'
    @user2.email = 'uno@email.com'
    assert_not @user2.save
  end

  test "Should fail create user without first_name" do
    user = User.new(
      first_name: nil, last_name: 'test', email: 'test@test.com',
      birthday: Date.today, encrypted_password: 'test', country: 'test'
    )
    assert_not user.save
  end

  test "Should fail create user without last_name" do
    user = User.new(
      first_name: 'test', last_name: nil, email: 'test@test.com',
      birthday: Date.today, encrypted_password: 'test', country: 'test'
    )
    assert_not user.save
  end

  test "Should fail create user without email" do
    user = User.new(
      first_name: 'test', last_name: 'test', email: nil,
      birthday: Date.today, encrypted_password: 'test', country: 'test'
    )
    assert_not user.save
  end

  test "Should fail create user without birthday" do
    user = User.new(
      first_name: 'test', last_name: 'test', email: 'test@test.com',
      birthday: nil, encrypted_password: 'test', country: 'test'
    )
    assert_not user.save
  end

  test "Should fail create user without password" do
    user = User.new(
      first_name: 'test', last_name: 'test', email: 'test@test.com',
      birthday: Date.today, encrypted_password: nil, country: 'test'
    )
    assert_not user.save
  end

  test "Should fail create user without country" do
    user = User.new(
      first_name: 'test', last_name: 'test', email: 'test@test.com',
      birthday: Date.today, encrypted_password: 'test', country: nil
    )
    assert_not user.save
  end
end
