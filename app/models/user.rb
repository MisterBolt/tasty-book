class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable

  validates :username, uniqueness: true, presence: true
  validates_with UsernameValidator
  validates_with UserImageValidator

  before_save :resize_avatar, unless: :persisted?

  has_one_attached :avatar

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scored_recipes,
    through: :recipe_scores,
    source: :recipe

  has_many :recipes

  has_many :cook_books,
    dependent: :destroy

  has_many :comments

  # returns an array of follows a user gave to someone else
  has_many :given_follows,
    class_name: "Follow",
    foreign_key: :follower_id,
    dependent: :destroy
  # returns an array of other users who the user has followed
  has_many :followings,
    through: :given_follows,
    source: :followed_user
  # returns an array of follows for the given user instance
  has_many :received_follows,
    class_name: "Follow",
    foreign_key: :followed_user_id,
    dependent: :destroy
  # returns an array of users who follow the user instance
  has_many :followers,
    through: :received_follows,
    source: :follower

  def follow(other_user)
    given_follows.create(followed_user_id: other_user.id) unless self == other_user
  end

  def unfollow(other_user)
    given_follows.find_by(followed_user_id: other_user.id).destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def default_or_attached_avatar
    if avatar.attached?
      avatar
    else
      "https://res.cloudinary.com/hp7f0176d/image/upload/v1629268606/sample/blank-profile-picture.png"
    end
  end

  private

  def resize_avatar
    return unless avatar.attached?

    path = attachment_changes["avatar"].attachable.tempfile.path
    v_filename = avatar.filename
    v_content_type = avatar.content_type
    resized_image = ImageProcessing::MiniMagick.source(path).resize_to_fill!(150, 150)
    avatar.attach(io: File.open(resized_image.path), filename: v_filename, content_type: v_content_type)
  end
end
