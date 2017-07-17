class CartPage < BasePage

  checkbox(:terms_of_services_checkbox, id: 'termsofservice')
  button(:checkout_button , id: 'checkout')
  button(:checkout_as_guest_button , class: 'checkout-as-guest-button')

  def start_checkout
   check_terms_of_services_checkbox
   change_page_using :checkout_button
  end

  def start_checkout_as_guest
   start_checkout
   change_page_using :checkout_as_guest_button
  end

end