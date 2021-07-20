class RecipeScore < ApplicationRecord
  SCORE = (1..5).to_a.freeze

  validates :user_id, presence: true, uniqueness: {scope: :recipe_id}
  validates :recipe_id, presence: true
  validates :score, presence: true, inclusion: {in: SCORE}

  belongs_to :user
  belongs_to :recipe
end
