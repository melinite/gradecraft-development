require 'test_helper'

class GradeTest < ActionDispatch::IntegrationTest

  test "test grade index as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_assignment
    create_grade
    visit assignment_path(assignment)
    page.text.must_include "TEST ASSIGNMENT"
    page.text.must_include "99"
  end

#new

  test "test grade show as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')

    visit assignment_grade_path(assignment, grade)
    page.text.must_include "Test Assignment"
    page.text.must_include "99"
  end


#edit

#delete

#mass grade

end