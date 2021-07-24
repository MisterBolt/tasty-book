# frozen_string_literal: true

class CookBooksController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_visibilities, only: [:index]

  def index
    @cook_book = CookBook.new
    @cook_books = CookBook.all
  end

  def create
    @cook_book = CookBook.new(cook_book_params)
    @cook_book.user = current_user
    if @cook_book.save
      redirect_to(cook_books_path, notice: t(".notice"))
    else
      redirect_to(cook_books_path, alert: @cook_book.errors.full_messages[0])
    end
  end

  private

  def set_visibilities
    @visibilities = CookBook.visibilities.map { |key, value| [key.humanize, key] }
  end

  def cook_book_params
    params.require(:cook_book).permit(:title, :visibility)
  end
end
