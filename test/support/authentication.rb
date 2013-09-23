module Authentication
  def log_in(email, password)
    visit '/'
    click_link 'GradeCraft Login'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Log in'
    if block_given?
      yield
      log_out
    end
  end

  def log_out
    visit '/logout'
  end
end
