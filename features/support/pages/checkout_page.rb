class CheckoutPage < BasePage

  text_field(:first_name,  id: 'BillingNewAddress_FirstName')
  text_field(:last_name, id: 'BillingNewAddress_LastName')
  text_field(:email, id: 'BillingNewAddress_Email')
  select(:country , id: 'BillingNewAddress_CountryId')
  select(:state , id: 'BillingNewAddress_StateProvinceId')
  text_field(:city, id: 'BillingNewAddress_City')
  text_field(:address1 , id: 'BillingNewAddress_Address1')
  text_field(:zip_code , id: 'BillingNewAddress_ZipPostalCode')
  text_field(:phone_number , id: 'BillingNewAddress_PhoneNumber')
  button(:billing_address_continue_button , class: 'button-1 new-address-next-step-button')
  div(:shipping_button_container, id: 'shipping-buttons-container')
  radio_button(:next_day_air ,value: 'Next Day Air___Shipping.FixedRate')
  radio_button(:ground , value: 'Ground___Shipping.FixedRate')
  radio_button(:second_day_air, value: '2nd Day Air___Shipping.FixedRate')

def billing_continue
  billing_address_continue_button
  wait_for_ajax
end

def shipping_continue
 # @browser.button(:onclick=> 'Shipping.save()', :value=> 'Continue').click
   shipping_button_container_element.button(class: 'button-1 new-address-next-step-button').click
end

  def shipping_method(shipping)
    send("select_#{shipping.to_s.downcase.gsub!(' ', '_')}".to_sym)
    sleep 5
  end

end