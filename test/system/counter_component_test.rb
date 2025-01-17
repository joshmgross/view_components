# frozen_string_literal: true

require "application_system_test_case"

class IntegrationCounterComponentTest < ApplicationSystemTestCase
  def test_integration
    visit_preview(:default)

    assert_selector(".Counter", text: "1,000")
  end
end
