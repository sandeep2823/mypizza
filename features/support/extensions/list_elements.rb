# # Example usage
# browser = Watir::Browser.new
# browser.goto('your.page.com')
# el = browser.text_field(:id, 'foobar')
# puts el.list_attributes
# # => {"width": "200", "type": "text", "height": "100", "value": "zoo", "id": "foobar"}

module Watir
  class Element
    def list_attributes
      # attributes = browser.execute_script(%Q[
      #           var s = [];
      #           var attrs = arguments[0].attributes;
      #           for (var l = 0; l < attrs.length; ++l) {
      #               var a = attrs[l]; s.push(a.name + ': ' + a.value);
      #           } ;
      #           return s;],
      #                                     self)
      # @browser.execute_script(' $timeout.cancel( timer );')
      attributes = browser.execute_script(%Q[
                var s = {};
                var attrs = arguments[0].attributes;
                for (var l = 0; l < attrs.length; ++l) {
                    var a = attrs[l]; s[a.name]=a.value;
                } ;
                return s;],
                                          self)
    end
  end
end