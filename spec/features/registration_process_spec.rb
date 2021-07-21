require 'rails_helper'

RSpec.describe "registration process", type: :feature do
    before { visit new_user_registration_path }

    scenario 'filling in correct data' do
        fill_in 'Username', with: 'username'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: "password"
        expect{
        click_button 'Sign up'
        }.to change(User, :count).by(1)
    end

    scenario 'leaving fields empty' do
        click_button "Sign up"
        expect(page).to have_content("can't be blank")
    end

    scenario 'filling in too short password' do
        fill_in 'Username', with: "username"
        fill_in 'Email', with: "user@example.com"
        fill_in 'Password', with: "p"
        fill_in "Password confirmation", with: "p"
        click_button "Sign up"
        expect(page).to have_content("Password is too short")
    end

    scenario 'filling in wrong password confirmation' do
        fill_in 'Username', with: "username"
        fill_in 'Email', with: "user@example.com"
        fill_in 'Password', with: "password"
        fill_in "Password confirmation", with: "different_password"
        click_button "Sign up"
        expect(page).to have_content("Password confirmation doesn't match Password")
    end

    scenario 'filling in taken username' do
        create(:user)

        fill_in 'Username', with: "John Doe"
        fill_in 'Email', with: "user@example.com"
        fill_in 'Password', with: "password"
        fill_in "Password confirmation", with: "password"
        click_button "Sign up"
        expect(page).to have_content("Username has already been taken")
    end

    scenario 'filling in taken email' do
        create(:user)

        fill_in 'Username', with: "username"
        fill_in 'Email', with: "john.doe@example.com"
        fill_in 'Password', with: "password"
        fill_in "Password confirmation", with: "password"
        click_button "Sign up"
        expect(page).to have_content("Email has already been taken")
    end
end