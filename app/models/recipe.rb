# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :title, presence: true
  validates :preparation_description, presence: true
  validates :time_in_minutes_needed, presence: true
  validates :difficulty, presence: true
  enum difficulty: {EASY: 0, MEDIUM: 1, HARD: 2}

  belongs_to :user

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scorers,
    through: :recipe_scores,
    source: :user

  has_many :comments, dependent: :destroy

  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  
  belongs_to :user

  has_and_belongs_to_many :cook_books
end
