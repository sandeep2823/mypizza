## PageObject namespace for monkey patching
module PageObject
  # rubocop:disable Metrics/AbcSize
  extend Forwardable
  def_delegators :root, :visible?, :present?, :exists?

  def change_page_using(element, opts={})
    opts[:current_url] = @browser.url

    begin
      self.send(element.to_sym)
      wait_for_ajax
    rescue
      # show_left_nav
      wait_for_ajax
      self.send(element.to_sym)
    end

    wait_for_url_change(opts)
  end

  def wait_for_url_change(opts={})
    url_now = opts.fetch(:current_url, @browser.url)
    Watir::Wait.until { @browser.url != url_now }
    wait_for_ajax
    page = nil
    page = on_page(opts[:target_page].to_s.to_page_class) if opts[:target_page]
    opts[:factory].current_page = page if opts[:factory]
    page
  end

  ##
  # :category: extensions
  #
  # Waits until the element is present
  #
  # @param [Integer] (defaults to: 5) seconds to wait before timing out
  #
  def when_present(timeout = ::PageObject.default_element_wait)
    wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: "Element not present in #{timeout} seconds")
    wait.until do
      root.exists?
    end
    self
  end

  ##
  # :category: extensions
  #
  # Waits until the element is not present
  #
  # @param [Integer] (defaults to: 5) seconds to wait before
  # timing out
  #
  def when_not_present(timeout = ::PageObject.default_element_wait)
    wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: "Element still present in #{timeout} seconds")
    wait.until do
      not_present = false
      begin
        not_present = false if root && root.displayed?
      rescue Selenium::WebDriver::Error::ObsoleteElementError
        not_present = true
      end
      not_present
    end
  end

  ##
  # :category: extensions
  #
  # Waits until the element is visible
  #
  # @param [Integer] (defaults to: 5) seconds to wait before timing out
  #
  def when_visible(timeout = ::PageObject.default_element_wait)
    wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: "Element not visible in #{timeout} seconds")
    wait.until do
      root.visible?
    end
    self
  end

  ##
  # :category: extensions
  #
  # Waits until the element is not visible
  #
  # @param [Integer] (defaults to: 5) seconds to wait before timing out
  #
  def when_not_visible(timeout = ::PageObject.default_element_wait)
    wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: "Element still visible in #{timeout} seconds")
    wait.until do
      !root.visible?
    end
    self
  end

  ##
  # :category: extensions
  #
  # Wait for ajax calls to complete
  # This differs from the stock wait_for_ajax in that it does not blow up while page navigation is occuring
  #
  def wait_for_ajax(timeout = 30, message = nil)
    sleep 0.5 # Give the browser time to start it's ajax requests
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      begin
        pending = browser.execute_script(::PageObject::JavascriptFrameworkFacade.pending_requests)
      rescue Selenium::WebDriver::Error::UnknownError
        pending = 1
      end

      return if pending == 0
      sleep 0.5
    end
    message = 'Timed out waiting for ajax requests to complete' unless message
    raise message
  end

  def fresh_root
    @browser.element(root.element.instance_variable_get('@selector'))
  end

  ## PageObject::Accessors namespace for monkey patching
  module Accessors
    def select_list(name, identifier = { index: 0 }, &block)
      standard_methods(name, identifier, 'select_list_for', &block)
      define_method(name) do
        return platform.select_list_value_for identifier.clone unless block_given?
        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").fire_event :click
        send("#{name}_element").select(value)
        send("#{name}_element").fire_event :blur
      end
      define_method("#{name}_options") do
        element = send("#{name}_element")
        (element && element.options) ? element.options.collect(&:text) : []
      end
    end

    ##
    # :category: extensions
    #
    # Add a link field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_button(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a div field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_div(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a link field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_link(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a select list that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_select_list(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
      define_method("#{name}=") do |value|
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}=", value)
      end
      define_method("#{name}_options") do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_options")
      end
    end

    ##
    # :category: extensions
    #
    # Add a text field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_text_field(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element").value
      end
      define_method("#{name}=") do |value|
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element").value = value
      end
    end

    ##
    # :category: extensions
    #
    # This mimics the behavior of standard_methods for depricated fields.  This is called by depreciated_text_field
    #
    def depreciated_standard_methods(name, new_name)
      define_method("#{name}_element") do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element")
      end
      define_method("#{name}?") do
        STDERR.puts "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}?")
      end
    end

    #
    # adds four methods to the page object - one to set text in a masked text field,
    # another to retrieve text from a text field, another to return the text
    # field element, another to check the text field's existence.
    #
    # After setting the value, the blur event will be fired on the control
    #
    # @example
    #   text_field(:first_name, :id => "first_name")
    #   # will generate 'first_name', 'first_name=', 'first_name_element',
    #   # 'first_name?' methods
    #
    # @param  [String] the name used for the generated methods
    # @param [Hash] identifier how we find a text field.  You can use a multiple parameters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class => Watir and Selenium
    #   * :css => Selenium only
    #   * :id => Watir and Selenium
    #   * :index => Watir and Selenium
    #   * :label => Watir and Selenium
    #   * :name => Watir and Selenium
    #   * :text => Watir and Selenium
    #   * :title => Watir and Selenium
    #   * :value => Watir only
    #   * :xpath => Watir and Selenium
    # @param optional block to be invoked when element method is called
    #
    def masked_text_field(name, identifier = { index: 0 }, &block)
      standard_methods(name, identifier, 'text_field_for', &block)
      define_method(name) do
        return platform.text_field_value_for identifier.clone unless block_given?
        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return platform.text_field_value_set(identifier.clone, value) unless block_given?
        send("#{name}_element").value = value
        send("#{name}_element").fire_event 'blur'
      end
    end
  end
  module PageFactory
    attr_accessor :current_page
    def on_current_page(&block)
      yield @current_page if block
      @current_page
    end
  end

  module Javascript

    module SciFinder
      #
      # return the number of pending ajax requests
      #
      def self.pending_requests
        'return jQuery.active;'
      end
    end

  end

  # rubocop:enable Metrics/AbcSize
end
