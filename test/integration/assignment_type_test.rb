require 'test_helper'

class AssignmentTypeTest < ActionDispatch::IntegrationTest

  #view assignment type index
  test "assignment type index as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'GradeCraft Login'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_assignment_type
    visit assignment_types_path
    page.text.must_include "Test Assignment Type"
  end

  #new assignment type

  #show assignment type
  test "assignment type show as professor" do
    create_professor(email: 'sev@hogwarts.edu', password: 'password')

    visit assignment_type_path(assignment_type)
    page.text.must_include "TEST ASSIGNMENT TYPE"
  end


  #edit assignment type
  test "assignment type edit as professor" do
    visit edit_assignment_type_path(assignment_type)
    page.text.must_include "Test Assignment Type"
  end

  #delete assignment type

end