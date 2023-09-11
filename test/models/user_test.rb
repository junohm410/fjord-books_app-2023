# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User#name_or_email should return name if user has no name" do
    assert_equal 'alice@example.com', users(:alice).name_or_email
  end

  test "User#name_or_email should return name if user has name" do
    assert_equal 'bob', users(:bob).name_or_email
  end
end
