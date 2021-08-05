module UsersHelper
  def user_avatar_for(user, size: nil)
    # TODO select correct foto for user
    image_tag("/images/blank-profile-picture.png", class: "flex-none rounded-lg object-cover bg-gray-100", id: "user-image", size: size)
  end
end
