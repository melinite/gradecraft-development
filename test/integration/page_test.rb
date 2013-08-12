require 'test_helper'

class PageTest < ActionDispatch::IntegrationTest

  test "contact" do
    visit '/contact'
    page.must_have_content 'Contact'
  end

  test "features" do
    visit '/features'
    page.must_have_content 'Features'
  end

  test "news" do
    visit '/news'
    page.must_have_content 'News'
  end

  test "people" do
    visit '/people'
    page.must_have_content 'People'
  end

  test "research" do
    visit '/research'
    page.must_have_content 'Research'
  end

  test "submit a bug" do
    visit '/submit_a_bug'
    page.must_have_content 'Submit a Bug'
  end

  test "using gradecraft" do
    visit '/using_gradecraft'
    page.must_have_content 'Using GradeCraft'
  end
end