require 'test_helper'
require "selenium-webdriver"

class AnimalsControllerTest < ActionController::TestCase
  setup do
    @animal = create(:animal)
    @animal2 = create(:animal)
    @animal3 = create(:animal)

    #@driver = Selenium::WebDriver.for :firefox
    #@driver.navigate.to "http://localhost:3000" #TODO: Reference a variable here
    
  end
  
  teardown do
    @animal.destroy
    @animal2.destroy
    @animal3.destroy

    #@driver.quit
  end 

  #TODO: This probably belongs elsewhere
  test "should let admin sign in" do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    a = create(:admin)
    result = sign_in :admin, a
  end

  test "should get index" do
    get :index
    assert_response :success
  end

 # test "should get index selinium" do
  #  element = @driver.execute_script("return document.body")
  #  shouldbebody = @driver.execute_script("return arguments[0].tagName", element) #=> "BODY"
  #  assert_equal(shouldbebody, "BODY");
 # end

  test "should get new" do
    a = create(:admin)
    sign_in :admin, a
    get :new
    assert_response :success
  end

  test "should create animal" do
    a = create(:admin)
    sign_in :admin, a
    assert_difference('Animal.count') do
      r = post :create, :animal_id => @animal.id
      return Animal.count
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
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    a = create(:admin)
    result = sign_in :admin, a
    
    put :update, :id => @animal.to_param, :animal => @animal.attributes
    assert_redirected_to animal_path(assigns(:animal)
    assert_equal(@animal.id = @animal.to_param)

  end

  test "should destroy animal" do
    #logger.info "In should destroy animal"
     a = create(:admin)
    sign_in :admin, a
    #logger.info "right after sign-in, should destroy animal"
    assert_difference('Animal.count', -1) do
      delete :destroy, :id => @animal.id
      return Animal.count
    end

    assert_redirected_to animals_path
  end
end
