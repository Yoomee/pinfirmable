require "spec_helper"

RSpec.feature "User signup" do
  before do
    sign_up_user
  end

  scenario "redirects users to the pin confirmation page after signup" do
    expect(User.find_by(email: "test@example.com").pinfirmable_pin).to_not be_nil
    expect(page.current_path).to eq "/users/pinfirmable/new"
  end

  scenario "filling in a correct pin redirects to the root path" do
    user = User.find_by email: "test@example.com"
    fill_in "digits_1", with: user.pinfirmable_pin[0]
    fill_in "digits_2", with: user.pinfirmable_pin[1]
    fill_in "digits_3", with: user.pinfirmable_pin[2]
    fill_in "digits_4", with: user.pinfirmable_pin[3]
    fill_in "digits_5", with: user.pinfirmable_pin[4]
    fill_in "digits_6", with: user.pinfirmable_pin[5]
    click_button "GO!"
    expect(page.current_path).to eq "/"
  end

  scenario "filling in an incorrect pin redirects to the pin path" do
    fill_in "digits_1", with: "1"
    fill_in "digits_2", with: "2"
    fill_in "digits_3", with: "3"
    fill_in "digits_4", with: "4"
    click_button "GO!"
    expect(page.current_path).to eq "/users/pinfirmable/new"
  end

  scenario "sends an email with the pin" do
    pin_email = ActionMailer::Base.deliveries.last
    user = User.find_by email: "test@example.com"
    expect(pin_email.subject).to eq("Confirmation code: #{user.pinfirmable_pin[0..2]}-#{user.pinfirmable_pin[3..6]}")
  end

  def sign_up_user
    visit new_user_registration_path
    fill_in "user_email", with: "test@example.com"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"
  end
end
