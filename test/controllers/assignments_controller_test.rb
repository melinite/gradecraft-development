require "test_helper"

class AssignmentsControllerTest < ActionController::TestCase
  
  fixtures :assignments

  test "should get index" do
    get :index
    assert_response :success 
    assert_not_nil assigns(:assignments)
  end

  test "should get new" do get :new
    assert_response :success
  end
  
  test "should create assignment" do 
    assert_difference('Assignment.count') do
      post :create, assignment: @update
    end
    
    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should update assignment" do
    patch :update, id: @assignment, assignment: @update 
    assert_redirected_to assignment_path(assigns(:assignment))
  end
end
