require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  test "home" do
    visit '/'
    page.must_have_content 'GradeCraft'
  end

  test "log in" do
    @professor = create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')

    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'dumbledore@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    page.must_have_content 'Top 10'
  end
end
