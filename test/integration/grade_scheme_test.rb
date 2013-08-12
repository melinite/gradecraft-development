require 'test_helper'

class GradeSchemeTest < ActionDispatch::IntegrationTest

  test "test grade scheme index as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'dumble@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_grade_scheme
    visit grade_schemes_path
    page.text.must_include "NEWT"
  end

#new

  test "test grade scheme show as professor" do
    create_professor(email: 'dumble@hogwarts.edu', password: 'password')

    visit grade_scheme_path(grade_scheme)
    page.text.must_include "NEWT"
  end


#edit

#delete

end