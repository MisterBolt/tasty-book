class CookBook < ApplicationRecord
  enum visibility: {public: 0, private: 1, followers: 2}, _prefix: true

  validates_presence_of :title
  validates_inclusion_of :visibility, in: visibilities
  validates_inclusion_of :favourite, in: [true, false]

  belongs_to :user
  has_and_belongs_to_many :recipes

  scope :user, ->(user_id) { where(user_id: user_id) }
  scope :visible_publicly, -> { where(visibility: :public) }
  scope :followers, ->(followings, current_user_id) do
    where(visibility: :followers, user_id: followings.ids.push(current_user_id))
  end
end
