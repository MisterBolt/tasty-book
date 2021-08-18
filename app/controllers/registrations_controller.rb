# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    unless sign_up_params[:avatar].nil?
      resize_avatar
    end

    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      CookBook.create!(user: resource, title: "Favourites", visibility: :private, favourite: true)

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private
  
  def resize_avatar
    path = sign_up_params[:avatar].tempfile.path
    sign_up_params[:avatar].tempfile = ImageProcessing::MiniMagick.source(path)
      .resize_to_fill!(150, 150)
  end
end
