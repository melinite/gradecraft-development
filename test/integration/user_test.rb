require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest

  test "test user index as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_student
    visit students_users_path
    page.text.must_include "Test User"
  end

#new

  test "test student show as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')

    visit users_path(student)
    page.text.must_include "TEST USER"
    page.text.must_include "Current Score is"
  end


#edit

#delete

end