# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    super do
      if resource.persisted?
        CookBook.create!(user: resource, title: "Favourites", visibility: :private, favourite: true)
      end
    end
  end
end
