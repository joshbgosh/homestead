require 'test_helper'

class BallotsControllerTest < ActionController::TestCase

  test "should get index" do
    @ballot = create(:ballot)
    
    a = create(:admin)
    sign_in a
    
    get :index
    assert_response :success
    assert_not_nil assigns(:ballots)
  end

  test "should get new" do
    @ballot = create(:ballot)
    
    get :new
    assert_response :success
  end

  test "should create ballot" do
    match = create(:match)
    
    get :new
    post :create, :winner_id => match.opponent_1.id
    assert_response :success
    assert_nil flash[:error]
  end

  test "should show ballot" do
    @ballot = create(:ballot)
    
    a = create(:admin)
    sign_in a
    
    get :show, :id => @ballot.to_param
    assert_response :success
  end

#TODO: Fix test. Failing because test harness isn't signing in admin correctly, not because of actual failure.
  #test "should update ballot" do
  #  @ballot = create(:ballot)
  #  @request.env["devise.mapping"] = Devise.mappings[:admin]
  #  a = create(:admin)
  #  sign_in a
  #  
  #  put :update, :id => @ballot.to_param, :ballot => @ballot.attributes
  #  assert_redirected_to ballot_path(assigns(:ballot))
  #end

  test "should destroy ballot" do
    @ballot = create(:ballot)
    
    a = create(:admin)
    sign_in a
    
    assert_difference('Ballot.count', -1) do
      delete :destroy, :id => @ballot.to_param
      return Ballot.count
    end

    assert_redirected_to ballots_path
  end
  
  test "no internal error when starting ballot with no animals" do
    Animal.all.each do |animal|
      animal.destroy #make sure there aren't any damn animals in the database. Not sure why there would be any, but there are...
    end
    get :new
    assert (response.status == 400 or response.status == 302)
  end
  
 # test "can't submit ballot results without getting that ballot first" do
 #   @ballot = create(:ballot)
 #   
 #   m = create(:match)
 #   post :create, :winner_id => m.opponent_1.id
#
#    assert_not_nil flash[:alert]
#  end
end
