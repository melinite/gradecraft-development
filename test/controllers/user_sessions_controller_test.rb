class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end
 
  test "should login" do
    dumbledore = users(:one)
    post :create, :name => dumbledore.name, :password => 'fawkes'
    assert_redirected_to admin_url
    assert_equal dumbledore.id, session[:user_id]
  end
 
  test "should fail login" do
    dumbledore = users(:one)
    post :create, :name => dumbledore.name, :password => 'phoenix'
    assert_redirected_to login_url
  end
 
  test "should logout" do
    delete :destroy
    assert_redirected_to store_url
  end
 
end