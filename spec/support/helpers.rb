def fill_in_and_log_in(email, password, check_rememeber_me = false)
  within("#new_user") do
    fill_in "Email", with: email
    fill_in "Password", with: password

    check "user_remember_me" if check_rememeber_me
  end

  click_button I18n.t("buttons.log_in")
end

def fill_in_and_sign_up(username, email, password, password_conf, avatar = "#{Rails.root}/spec/files/avatar.png")
  fill_in "Email", with: email
  fill_in "Username", with: username
  fill_in "Password", with: password
  fill_in "Password confirmation", with: password_conf
  attach_file "user_avatar", avatar

  click_button I18n.t("buttons.sign_up")
end

def fill_in_and_resend_confirmation(email)
  within("#new_user") { fill_in "Email", with: email }

  click_button I18n.t("devise.confirmations.resend_confirmation")
end

def fill_in_recipe_data(title, description, time)
  fill_in "Title", with: title
  fill_in "Preparation description", with: description
  fill_in "Time needed (in minutes)", with: time
end

def add_ingredient_to_recipe(ingredient, quantity, unit)
  find(:css, "#add_ingredient").click
  #find(:css, "input[list='ingredients_dropdown']").set(ingredient)
  fill_in "Quantity", with: quantity
  select unit, from: "Unit"
  click_button I18n.t("buttons.add_ingredient")
end
