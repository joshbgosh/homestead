require 'test_helper'
require 'logger'

class AnimalsControllerTest < ActionController::TestCase
  setup do
    logger.info "About to create fake animal thing"
    @animal = create(:animal)
  end
  
  teardown do
    logger.info "destroying animal thing"
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
    logger.info "In: should create animal"
    a = create(:admin)
    sleep(1)
    logger.info "okay, so I should've just created it, and now I'm gonna sign in with it"
    sleep(1)
    debugger
    result = sign_in :admin, a
    puts result.to_s + "...result"
    logger.info "right after sign-in, should create animal"
    assert_difference('Animal.count') do
      logger.info "about to post"
      r = post :create, :animal_id => @animal.id
      puts response
      puts @response.body
      puts response.body
      puts r
      puts response.headers
      puts response.body.to_s
      logger.info "after post. What went wrong?"
    end

    assert_redirected_to animal_path(assigns(:animal))
  end

  test "should show animal" do
    logger.info "In: show animal"
    get :show, :id => @animal.to_param
    assert_response :success
    logger.info "Leaving show animal"
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
    logger.info "In should destroy animal"
    a = create(:admin)
    sign_in(a)
    logger.info "right after sign-in, should destroy animal"
    assert_difference('Animal.count', -1) do
      delete :destroy, :id => @animal.id
    end

    assert_redirected_to animals_path
  end
end
