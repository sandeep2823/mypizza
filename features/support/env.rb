require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'rubocop'
require 'axe/cucumber/step_definitions'
require 'rest-client'
require 'facets'
require 'data_magic'
require 'page-object'
require 'watir'
require 'require_all'
require 'sauce_whisk'
require 'pry'
require_all 'features/support/extensions/**/*.rb'
require_all 'features/support/helpers/**/*.rb'
require_all 'features/support/pages/**/*.rb'

# Set up PageObject world
World(PageObject::PageFactory)
World(DataMagic)

PageObject.default_element_wait = 15
PageObject::JavascriptFrameworkFacade.add_framework :sci_finder, ::PageObject::Javascript::SciFinder
PageObject::JavascriptFrameworkFacade.framework = :sci_finder

# Set Screenshot directory
SCREENSHOT_DIR = 'screenshots/'.freeze



#profile = Selenium::WebDriver::Chrome::Profile.new
#profile['credentials_enable_service'] = false
#profile['password_manager_enabled'] = false
#profile['autofill.enabled'] = false

binding.pry if ENV['CUKE_ENV_DEBUG'].to_s == 'true'
#@browser = Watir::Browser.new :chrome, :profile => profile
# raise 'TEST_ENV is not set' if ENV['TEST_ENV'].nil?

Watir.angular_patch!
