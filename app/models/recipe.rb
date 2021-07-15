class Recipe < ApplicationRecord
  has_many :recipe_scores,
    dependent: :destroy

  has_many :scorers,
    through: :recipe_scores,
    source: :user
  has_many :comments, dependent: :destroy
end
