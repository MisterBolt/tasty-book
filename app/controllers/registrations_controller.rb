# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    CookBook.create!(user: resource, title: "Favourites", visibility: :private, favourite: true)
    after_sign_in_path_for(resource)
  end
end
