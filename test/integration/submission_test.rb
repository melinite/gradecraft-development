require 'test_helper'

class SubmissionTest < ActionDispatch::IntegrationTest

  test "test submission index as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'GradeCraft Login'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_assignment
    create_submission
    visit assignment_path(assignment)
    page.text.must_include "TEST ASSIGNMENT"
    page.text.must_include "MyString"
  end

#new

  test "test submission show as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')

    visit assignment_submission_path(assignment, submission)
    page.text.must_include "Test Assignment"
    page.text.must_include "MyString"
  end


#edit

#delete

#mass grade

end