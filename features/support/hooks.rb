Before do |scenario|
  @browser = HookHelper.create_browser(scenario)
  #binding.pry

  FixtureHelper.load_fixtures_for(scenario)
  #puts "#{scenario} is starting"
end

After do |scenario|
  #puts "#{scenario} is ending"
  begin
    if scenario.failed?
      puts 'we had a failure'
      time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      FileUtils.mkdir_p SCREENSHOT_DIR
      filename = "#{SCREENSHOT_DIR}error-#{@current_page.class}-#{time}.png"
      @current_page.save_screenshot(filename) unless @current_page.nil?
      embed(filename, 'image/png')
      Cucumber.wants_to_quit = ENV['FAIL_FAST'].to_s == 'true'
    end
  rescue Exception => ex
    STDERR.puts "Exception thrown in after hook: #{ex.message}"
  end

  if ENV['CUKE_DEBUG'].to_s.casecmp('true').zero? && scenario.failed?
    STDOUT.puts "Debugging scenario: #{scenario.title}"
    binding.pry; 2
  end

  HookHelper.save_remote_results(scenario, @browser) if ENV.fetch('BROWSER_TYPE', 'local').downcase.to_sym == :remote

  @browser.close
end

Before('@wip, @ci') do
  # This will only run before scenarios tagged
  # with @wip OR @ci.
end

AfterStep('@wip', '@ci') do
  # This will only run after steps within scenarios tagged
  # with @wip AND @ci.
end

# Pause after each N steps based on the setting
AfterStep do |scenario|
  next unless ENV['CUKE_STEP_SIZE'].to_s.to_i > 0

  if scenario.class == Cucumber::Ast::OutlineTable::ExampleRow
    title = scenario.scenario_outline.title
    step_count = scenario.scenario_outline.raw_steps.count
  else
    title = scenario.title
    step_count = scenario.steps.count
  end

  unless defined?(@step_counter)
    STDOUT.puts "Stepping through #{title}"
    @step_counter = 0
  end

  @step_counter += 1

  STDOUT.puts "At step ##{@step_counter} of #{step_count}. Press Return to execute..."
  STDIN.getc
  STDOUT.puts 'Executing next step'
end
