class Product
  include PageObject

  def initialize(root, b)
    @root = root
    @browser = b
  end

  def product_name_element
    @root.h2_element(class: 'product-title')
  end

  def product_name
    product_name_element.text
  end

  def view_details_element
    product_name_element.link_elements.first
  end

  def view_details
    view_details_element.click
  end

  def actual_price_element
    @root.span_element(class: 'price actual-price')
  end

  def actual_price
    actual_price_element.text
  end

  def add_to_cart_element
    @root.button_element( class: 'product-box-add-to-cart-button')
  end

  def close_alert
    alert = @browser.span(class: 'close')
    alert.click if alert.visible?
  end

  def add_to_cart
    add_to_cart_element.click
    wait_for_ajax
    close_alert
    sleep 2
  end

end