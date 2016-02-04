require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
        password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email addr format validation" do
    valid_addr = %w[u@e.c USER@foo.COM u__s-e-r@test.com test.user@ex.te.st t+e@s.t]
    valid_addr.each do |va|
      @user.email = va
      assert @user.valid?, "#{va.inspect} should be valid"
    end
  end

  test "email addr format invalid entries" do
    invalid_addr = %w[abc@ex,com suer_at_test.org what@is. u@s_e.r t@e+s.t]
    invalid_addr.each do |ia|
      @user.email = ia
      assert_not @user.valid?, "#{ia.inspect} should be invalid"
    end
  end

  test "email addr should be unique" do
    dupe_user = @user.dup
    dupe_user.email = @user.email.upcase
    @user.save
    assert_not dupe_user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 10
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end
end
