# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :title, presence: true

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scorers,
    through: :recipe_scores,
    source: :user
     
  has_many :comments, dependent: :destroy
  
  belongs_to :user
end
