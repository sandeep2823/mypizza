module HookHelper
  def self.create_browser(scenario)
    # figure out local or remote first, if remote avoid local creation
    browser_type = ENV.fetch('BROWSER_TYPE', 'local').downcase.to_sym
    return create_remote_browser(scenario) if browser_type == :remote

    # if local, launch local broswer
    create_local_browser ENV.fetch('BROWSER', 'chrome').downcase.to_sym
  end

  def self.create_remote_browser(scenario)
    caps = sauce_caps(scenario)
    url = 'http://Justjoehere:4bea1fca-917b-4970-b97f-3fe09d104f77@ondemand.saucelabs.com:80/wd/hub'.strip

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 180

    Watir::Browser.new(:remote, url: url, desired_capabilities: caps, http_client: client)
  end

  def self.create_local_browser(browser_brand)
    browser_brand ||= :ff
    browser = Watir::Browser.new browser_brand
    unless ENV['BROWSER_RESOLUTION'].nil?
      resolution = ENV['BROWSER_RESOLUTION'].downcase.split('x')
      browser.window.resize_to(resolution[0].to_i, resolution[1].to_i)
    end

    browser
  end

  def self.sauce_caps(scenario)
    {
      version: ENV['SAUCE_VERSION'],
      browserName: ENV['BROWSER'],
      platform: ENV['SAUCE_PLATFORM'].to_s.tr('_', ' '),
      name: "#{scenario.feature.name} - #{scenario.name}",
      screenResolution: ENV['BROWSER_RESOLUTION']
    }
  end

  def self.save_remote_results(scenario, browser)
    session_id = browser.driver.send(:bridge).session_id

    if scenario.passed?
      SauceWhisk::Jobs.pass_job session_id
    else
      SauceWhisk::Jobs.fail_job session_id
    end
  end
end
