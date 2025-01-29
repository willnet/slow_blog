require "application_system_test_case"

class ToppageTest < ApplicationSystemTestCase
  test "the truth" do
    assert_queries_count_lteq 3 do
      visit root_path
    end
  end
end
