require 'test_helper'

class BattlesControllerTest < ActionController::TestCase

  test "should get index" do
    @battle = create(:battle)
    
    a = create(:admin)
    sign_in a
    
    get :index
    assert_response :success
    assert_not_nil assigns(:battles)
  end

  test "should get new" do
    @battle = create(:battle)
    
    get :new
    assert_response :success
  end

  test "should create battle" do
    match = create(:match)
    
    get :new
    post :create, :winner_id => match.opponent_1.id
    assert_response :success
    assert_nil flash[:error]
  end

  test "should show battle" do
    @battle = create(:battle)
    
    a = create(:admin)
    sign_in a
    
    get :show, :id => @battle.to_param
    assert_response :success
  end

  test "should update battle" do
    @battle = create(:battle)
    
    a = create(:admin)
    sign_in a
    
    put :update, :id => @battle.to_param, :battle => @battle.attributes
    assert_redirected_to battle_path(assigns(:battle))
  end

  test "should destroy battle" do
    @battle = create(:battle)
    
    a = create(:admin)
    sign_in a
    
    assert_difference('Battle.count', -1) do
      delete :destroy, :id => @battle.to_param
    end

    assert_redirected_to battles_path
  end
  
  test "no internal error when starting battle with no animals" do
    Animal.all.each do |animal|
      animal.destroy #make sure there aren't any damn animals in the database. Not sure why there would be any, but there are...
    end
    get :new
    assert (response.status == 400 or response.status == 302)
  end
  
  test "can't submit battle results without getting that battle first" do
    @battle = create(:battle)
    
    m = create(:match)
    post :create, :winner_id => m.opponent_1.id
    assert_not_nil flash[:error]
  end
end
