require 'test_helper'

class AssignmentTypeTest < ActionDispatch::IntegrationTest

  test "test assignment type index as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_assignment_type
    visit assignment_types_path
    page.text.must_include "Test Assignment Type"
  end

#new

  test "test assignment type show as professor" do
    create_professor(email: 'sev@hogwarts.edu', password: 'password')

    visit assignment_type_path(assignment_type)
    page.text.must_include "TEST ASSIGNMENT TYPE"
  end


#edit

#delete

end