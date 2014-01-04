require 'test_helper'

class BadgeTest < ActionDispatch::IntegrationTest

  test "test badge index as professor" do
    create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')
    visit '/'
    click_link 'GradeCraft Login'
    fill_in 'Email', :with => 'dumbledore@hogwarts.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    create_badge
    visit badges_path
    page.text.must_include "Badge 0"
  end

#new

  test "test badge show as professor" do
    create_professor(email: 'dumbledore@hogwarts.edu', password: 'password')

    visit badge_path(badge)
    page.text.must_include "BADGE 1"
  end

#edit

#delete

#mass award

end