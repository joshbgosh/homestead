require 'test_helper'
require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://google.com"

element = driver.find_element(:name, 'q')
element.send_keys "Hello WebDriver!"
element.submit

puts driver.title

driver.quit

class AnimalsControllerTest < ActionController::TestCase
  setup do
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to "http://localhost:3000" #TODO: Reference a variable here
  end
  
  teardown do
    driver.quit
  end

  test "should get index" do
    element = driver.execute_script("return document.body")
    var shouldbebody = driver.execute_script("return arguments[0].tagName", element) #=> "BODY"
    assert_equal(shouldbebody, "BODY");
  end

end
