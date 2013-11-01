require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest

  def login_as_professor
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'GradeCraft Login'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end

  test "test user index as professor" do

    login_as_professor

    create_student
    visit students_path
    page.text.must_include "Test User"

  end

#new

  test "test student show as professor" do
    login_as_professor

    visit student_path(student)
    page.text.must_include "TEST USER"
    page.text.must_include "Current Score is"
  end


#edit

#delete

end
