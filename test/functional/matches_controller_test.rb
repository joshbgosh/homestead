require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  setup do
    @match = create(:match)
  end
  
  teardown do
    @match.destroy
  end

  test "should get index" do
    a = create(:admin)
    sign_in a
    
    get :index
    assert_response :success
    assert_not_nil assigns(:matches)
  end

  test "should create match" do
    a = create(:admin)
    sign_in a
    
    assert_difference('Match.count') do
      post :create, :match => @match.attributes
      return Match.count;
    end

    assert_redirected_to match_path(assigns(:match))
  end

  test "should show match" do
    a = create(:admin)
    sign_in a
    
    get :show, :id => @match.to_param
    assert_response :success
  end

  test "should get edit" do
    a = create(:admin)
    sign_in a
    
    get :edit, :id => @match.to_param
    assert_response :success
  end

  test "should update match" do
    a = create(:admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in a
    
    put :update, :id => @match.to_param, :match => @match.attributes
    assert_redirected_to match_path(assigns(:match))
  end

  test "should destroy match" do
    a = create(:admin)
    sign_in a
    
    assert_difference('Match.count', -1) do
      delete :destroy, :id => @match.to_param
      return Match.count;
    end
    
      assert_redirected_to matches_path
  end
    
end
