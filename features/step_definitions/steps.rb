Given(/^I have searched for (.*)$/) do |product|
  visit(MainPage).search_for product
end

And(/^I have added (.*) to my cart$/) do |product_name|
  on(MainPage) do |page|
    product = page.products.select { |p| p.product_name == product_name }.first
    product.add_to_cart
  end
end

And(/^I begin the checkout process as a guest$/) do
  on(MainPage) do |page|
    page.open_cart
  end

  on(CartPage) do |page|
    page.start_checkout_as_guest
  end

end

When(/^I enter billing information$/) do
  on(CheckoutPage) do |page|
    page.populate data_for :demo_billing
    page.billing_continue
    page.shipping_continue
  end
end

And(/^I select (.*) method$/) do |shipping|
  on(CheckoutPage) do |page|
    page.shipping_method(shipping)
  end
end

Given(/^I am on the main page$/) do
  visit MainPage
end

And(/^I click on the sign in button$/) do
  on(MainPage) do |page|
    page.sign_in
  end
end

And(/^I search "([^"]*)"$/) do |text|
  on(MainPage).search_for text
end

Then(/^I "([^"]*)" and "([^"]*)"$/) do |arg1, arg2|
  pending
end