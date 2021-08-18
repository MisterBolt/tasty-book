module UsersHelper
  def user_avatar_for(user, size: nil)
    image_tag(check_avatar(user), class: "flex-none rounded-lg object-cover bg-gray-100", id: "user-image", size: size)
  end

  def check_avatar(user)
    if user.avatar.attached?
      user.avatar
    else
      "https://res.cloudinary.com/hp7f0176d/image/upload/v1629268606/sample/blank-profile-picture.png"
    end
  end
end
