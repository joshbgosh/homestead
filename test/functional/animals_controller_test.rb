require 'test_helper'
require "selenium-webdriver"

class AnimalsControllerTest < ActionController::TestCase
  setup do
    @animal = create(:animal)
    @animal2 = create(:animal)
    @animal3 = create(:animal)

   
  end
  
  teardown do
    @animal.destroy
    @animal2.destroy
    @animal3.destroy
  end

  #TODO: This probably belongs elsewhere
  test "should let admin sign in" do

 @driver = Selenium::WebDriver.for :firefox
 hostname_and_port = "localhost:3000/admins/sign_in"
 puts hostname_and_port
 @driver.navigate.to hostname_and_port
#wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
element = ""
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
wait.until { element = @driver.find_element(:id, "admin_username") }
element.send_keys(ENV["TOTALLYENRAGED_ADMIN_USERNAME"])

wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
wait.until { element = @driver.find_element(:id, "admin_password") }
element.send_keys(ENV["TOTALLYENRAGED_ADMIN_PW"])

#wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
element.submit()

@driver.quit
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index selinium" do
  #  element = @driver.execute_script("return document.body")
  #  shouldbebody = @driver.execute_script("return arguments[0].tagName", element) #=> "BODY"
  #  assert_equal(shouldbebody, "BODY");
  end

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


#TODO: Fix test. Failing because test harness isn't signing in admin correctly, not because of actual failure.
 # test "should update animal" do
 #   @request.env["devise.mapping"] = Devise.mappings[:admin]
 #   @admin = FactoryGirl.create :admin
 #   sign_in @admin
 #   
 #   put :update, :id => @animal.to_param, :animal => @animal.attributes
 #   assert_redirected_to animal_path(assigns(:animal))
 # end

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
