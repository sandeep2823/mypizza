# rubocop:disable Metrics/PerceivedComplexity
module PageObject
  module PagePopulator
    #
    # This method will populate all matched page TextFields,
    # TextAreas, SelectLists, FileFields, Checkboxes, and Radio Buttons from the
    # Hash passed as an argument.  The way it find an element is by
    # matching the Hash key to the name you provided when declaring
    # the element on your page.
    #
    # Checkboxe and Radio Button values must be true or false.
    #
    # @example
    #   class ExamplePage
    #     include PageObject
    #
    #     text_field(:username, :id => 'username_id')
    #     checkbox(:active, :id => 'active_id')
    #   end
    #
    #   ...
    #
    #   @browser = Watir::Browser.new :firefox
    #   example_page = ExamplePage.new(@browser)
    #   example_page.populate_page_with :username => 'a name', :active => true
    #
    # @param [Hash] the data to use to populate this page.  The key
    # can be either a string or a symbol.  The value must be a string
    # for TextField, TextArea, SelectList, and FileField and must be true or
    # false for a Checkbox or RadioButton.
    #
    def populate_page_with(data)
      data.each do |key, value|
        populate_checkbox(key, value) if is_checkbox?(key) && is_enabled?(key)
        populate_radiobuttongroup(key, value) if is_radiobuttongroup?(key)
        populate_radiobutton(key, value) if is_radiobutton?(key) && is_enabled?(key)
        populate_select(key, value) if is_select?(key) && does_exist?(key)
        populate_text(key, value) if is_text?(key) && is_enabled?(key)
      end
    end

    private

    def does_exist?(key)
      element = self.send("#{key}_element")
      element.element.exist?
    end

    def populate_select(key, value)
      send("#{key}=", value)
    rescue
      # Swallow this
    end

    def is_select?(key)
      respond_to?("#{key}_options")
    end
  end
end
# rubocop:enable Metrics/PerceivedComplexity
