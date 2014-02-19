require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest

  # before { visit '/' }

  # describe "homepage text" do
  #   it "must have homepage text" do
  #     page.must_have_content("Welcome to GradeCraft")
  #   end

  #   it "must have a login link" do
  #     page.find_link('GradeCraft Login').wont_be_nil
  #   end

  #   it "logging in must redirect to the dashboard path" do
  #     create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')
  #     css_select('dd', '.tabgc') do
  #       fill_in 'Email', :with => 'dumbledore@hogwarts.edu'
  #       fill_in 'Password', :with => 'password'
  #       click_button 'Log in'
  #     end
  #     current_path.must_equal(dashboard_path)
  #   end
  # end

end