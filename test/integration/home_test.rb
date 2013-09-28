require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  test "home" do
    visit '/'
    page.must_have_content 'GradeCraft'
  end

  test "log in as professor" do
    create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')

    log_in 'dumbledore@hogwarts.edu', 'password'

    page.must_have_content 'Top 10'

    session.destroy
  end

  test "log in as student" do
    create_student(email: 'llovegood@hogwarts.edu', password: 'password')

    log_in 'ilovegood@hogwarts.edu', 'password'

    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'llovegood@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    page.must_have_content 'Your current score is'
  end
end
