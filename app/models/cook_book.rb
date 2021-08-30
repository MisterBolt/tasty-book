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

  def recipes_visible_for_user(user)
    if user.present?
      recipes.published.or(recipes.drafted.where(user_id: user.id))
    else
      recipes.published
    end
  end

  def self.visibilities_strings
    CookBook.visibilities.map { |key, value| [I18n.t("cook_books.visibilities.#{key}"), key] }
  end
end
