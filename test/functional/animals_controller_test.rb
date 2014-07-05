require 'test_helper'
#require 'logger'

class AnimalsControllerTest < ActionController::TestCase
  setup do
    @animal = create(:animal)
  end
  
  teardown do
    @animal.destroy
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    a = create(:admin)
    sign_in(a)
    get :new
    assert_response :success
  end

  test "should create animal" do
    a = create(:admin)
    result = sign_in :admin, a
    assert_difference('Animal.count') do
      r = post :create, :animal_id => @animal.id
    end

    assert_redirected_to animal_path(assigns(:animal))
  end

  test "should show animal" do
    get :show, :id => @animal.to_param
    assert_response :success
  end

  test "should get edit" do
    a = create(:admin)
    sign_in(a)
    get :edit, :id => @animal.to_param
    assert_response :success
  end

  test "should update animal" do
    a = create(:admin)
    sign_in(a)
    
    put :update, :id => @animal.to_param, :animal => @animal.attributes
    assert_redirected_to animal_path(assigns(:animal))
  end

  test "should destroy animal" do
    #logger.info "In should destroy animal"
    a = create(:admin)
    sign_in(a)
    #logger.info "right after sign-in, should destroy animal"
    assert_difference('Animal.count', -1) do
      delete :destroy, :id => @animal.id
    end

    assert_redirected_to animals_path
  end
end
