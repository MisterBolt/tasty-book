# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :title, presence: true
  validates :preparation_description, presence: true
  validates :time_in_minutes_needed, presence: true
  validates :difficulty, presence: true
  validates :categories, length: {maximum: 5}, presence: true
  validates :layout, presence: true

  validates :ingredients_recipes, length: {minimum: 1}

  enum difficulty: {EASY: 0, MEDIUM: 1, HARD: 2}
  enum layout: {layout_1: 0, layout_2: 1, layout_3: 2}

  belongs_to :user

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scorers,
    through: :recipe_scores,
    source: :user

  has_many :comments,
    dependent: :destroy

  has_many :ingredients_recipes,
    dependent: :destroy

  has_many :ingredients,
    through: :ingredients_recipes

  has_and_belongs_to_many :cook_books

  has_and_belongs_to_many :categories

  scope :sort_by_default, ->(sort_kind, sort_order) {
    order(sort_kind => sort_order)
  }
  scope :sort_by_score, ->(sort_order, nulls_presence) {
    left_outer_joins(:recipe_scores)
      .select("recipes.*")
      .group("recipes.id")
      .order("avg(recipe_scores.score) #{sort_order} #{nulls_presence}")
  }
  scope :sort_by_kind_and_order, ->(sort_kind, sort_order) do
    case sort_kind
    when "title", "difficulty", "time_in_minutes_needed"
      sort_by_default(sort_kind, sort_order)
    when "score"
      nulls_presence = sort_order == "DESC" ? "NULLS LAST" : "NULLS FIRST"
      sort_by_score(sort_order, nulls_presence)
    end
  end

  def cook_books_update(cook_book_ids_raw, user)
    cook_book_id_strings = cook_book_ids_raw.filter { |cook_book_id| cook_book_id != "" }
    cook_book_ids = cook_book_id_strings.map { |cook_book_id| cook_book_id.to_i }
    if cook_book_ids.all? { |cook_book_id| user.cook_books.ids.include?(cook_book_id) }
      cook_books.delete(CookBook.where(user_id: user.id))
      cook_books << CookBook.where(id: cook_book_ids)
    else
      false
    end
  end

  def average_score
    recipe_scores.average(:score).to_f.round(1)
  end

  def self.average_score
    joins(:recipe_scores)
      .pluck("avg(recipe_scores.score)")[0]
      .to_f.round(1)
  end
  accepts_nested_attributes_for :ingredients_recipes,
    allow_destroy: true,
    reject_if: ->(attributes) { attributes[:ingredient_name].blank? }
end
