require_relative 'header_section'

class MainPage < BasePage
   page_url ('http://staging.mypizzadev.com/' )
  # ul( :top_menu, class: 'top-menu')
  # text_field(:search_term, id: 'small-searchterms')
  # button(:search_button, value: 'Search')
   link(:sign_in_link, title: 'Sign in or create a Slice account')
   select(:shipping_type, name: 'search_shipping_type_filter')
   text_field(:search_pizza_restaurant, id: 'address-complete__input')
   button(:find_pizza_button, class: 'homepage-search__submit')

  def search_for(text)
    self.search_pizza_restaurant = text
    change_page_using :find_pizza_button
  end

  def open_cart
    change_page_using :open_cart_link
  end

  def products
    @products ||= div_elements(class: 'product-item').map { |e| Product.new(e, browser) }
  end

  def sign_in
    change_page_using :sign_in_link
  end

end