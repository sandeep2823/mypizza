class BasePage
  include PageObject
  include DataMagic
  include URLHelper
  include PageFactory

  def populate(data = {}, additional = {})
    populate_page_with data_for_or_default(self.class.to_s.snakecase, {}, additional) if data.empty?
    populate_page_with data unless data.empty?
  end

  def displayed?
    @browser.url == self.page_url_value
  end

  def fields_visible?(field_hash)
    failed_fields = []
    field_hash[:field].each do |field|
      failed_fields << field unless self.send("#{field}_element".snakecase.to_sym).visible?
    end
    failed_fields
  end

  def open_close_status_for(element_name)
    element = self.send("#{element_name.downcase.snakecase}_element")
    element.element.relocate
    return :open if element.class_name.include?('open')
    return :closed if element.class_name.include?('closed')
    raise "Could not determine open/closed status for #{element_name}"
  end

  def dismiss_modal(element)
    begin
      self.confirm(true) do
        element
      end
    rescue
      force_dismiss_modal
    end
  end

  def force_dismiss_modal
    begin
      @browser.alert.ok if @browser.alert.exists?
    rescue
      # If this fails the modal is already gone so swallow it
    end
  end
end
