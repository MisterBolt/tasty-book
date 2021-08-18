class CookBook < ApplicationRecord
  enum visibility: {public: 0, private: 1, followers: 2}, _prefix: true

  validates_presence_of :title
  validates_inclusion_of :visibility, in: visibilities
  validates_inclusion_of :favourite, in: [true, false]

  belongs_to :user
  has_and_belongs_to_many :recipes

  scope :for_public, -> { where(visibility: :public) }
  scope :for_followers, -> { where(visibility: :followers) }
  scope :for_public_and_followers, -> { where(visibility: [:public, :followers]) }
  scope :for_specific_followers, ->(followings_ids) do
    where(visibility: :followers, user_id: followings_ids)
  end
end
