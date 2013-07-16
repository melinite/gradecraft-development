require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  it "home test" do
    visit '/'
  end
end