# frozen_string_literal: true

class CookBooksController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_cook_book, only: [:show]

  def index
    @recipe = Recipe.new
    @cook_books = CookBook.all
  end

  def show
  end

  def create
    @cook_book = CookBook.new(cook_book_params)
    @cook_book.user = current_user
    if @recipe.save
      redirect_to(@recipe, notice: t(".notice"))
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def set_cook_book
    @recipe = Recipe.find(params[:id])
  end

  def cook_book_params
    params.require(:cook_book.permit(:title, recipe_ids: []))
  end
end
