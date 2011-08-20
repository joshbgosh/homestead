require 'test_helper'

class BattlesControllerTest < ActionController::TestCase
  setup do
    @battle = create(:battle)
  end
  
  teardown do
    @battle.destroy
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:battles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create battle" do
    assert_difference('Battle.count') do
      post :create, :battle => @battle.attributes
    end

    #assert_redirected_to battle_path(assigns(:battle))
  end

  test "should show battle" do
    get :show, :id => @battle.to_param
    assert_response :success
  end

  test "should update battle" do
    put :update, :id => @battle.to_param, :battle => @battle.attributes
    assert_redirected_to battle_path(assigns(:battle))
  end

  test "should destroy battle" do
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
    b = attributes_for(:battle)
    post :create, :battle => b
    assert_response :error
  end
end
