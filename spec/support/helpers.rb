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

def fill_in_and_send_reset_password_instructions(email)
  within("#new_user") { fill_in "Email", with: email }

  click_button I18n.t("devise.passwords.reset_password")
end

def fill_in_recipe_data(title, time)
  fill_in "Title", with: title
  fill_in "Time needed (in minutes)", with: time
end

def add_ingredients_to_recipe(how_many)
  how_many.times do
    add_ingredient(Ingredient.find(Ingredient.ids.sample).name, rand(1..10), rand(0..3))
  end
end

def add_sections_to_recipe(how_many)
  how_many.times do
    add_section("Random name", "Random body")
  end
end

def add_section(title, body)
  find(:css, "#add_section").click
  all("fieldset .section-title").last.set(title)
  all("fieldset .section-body").last.set(body)
end

def add_ingredient(name, quantity, unit)
  find(:css, "#add_ingredient").click
  all("fieldset input[list='ingredients_dropdown']").last.set(name)
  all("fieldset input[type='number']").last.set(quantity)
  all("fieldset select option")[unit].select_option
end

def remove_ingredients
  find(:css, ".delete-ingredient").click
end

def remove_categories
  page.all(:css, "input[checked='checked']").each do |btn|
    btn.click
  end
end

def remove_sections
  find(:css, ".delete-section").click
end

def add_categories
  Category.all.each do |c|
    find(:css, "input[value='#{c.id}']").set(true)
  end
end
