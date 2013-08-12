require 'test_helper'

class BadgeTest < ActionDispatch::IntegrationTest

  test "test badgeset index as professor" do
    create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'Log In'
    fill_in 'Email', :with => 'dumbledore@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_badge_set
    visit badge_sets_path
    page.text.must_include "Badge Set 0"
  end

#new

  test "test badgeset show as professor" do
    create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')

    visit badge_set_path(badge_set)
    page.text.must_include "BADGE SET 1"
  end

#edit

#delete

end