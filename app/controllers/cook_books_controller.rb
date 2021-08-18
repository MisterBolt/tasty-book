# frozen_string_literal: true

class CookBooksController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_visibilities, only: [:index]
  before_action :set_cook_book, only: [:show]

  def index
    @cook_book = CookBook.new
    @cook_books = policy_scope(CookBook).for_public_and_followers
    @pagy, @cook_books = pagy(@cook_books, items: per_page)
  end

  def show
  end

  def create
    @cook_book = CookBook.new(cook_book_params)
    @cook_book.user = current_user
    if @cook_book.save
      flash[:notice] = t(".notice")
    elsif @cook_book.valid?
      flash[:alert] = t(".alert")
    else
      flash[:alert] = @cook_book.errors.full_messages[0]
    end
    redirect_to(cook_books_path)
  end

  private

  def set_visibilities
    @visibilities = CookBook.visibilities.map { |key, value| [t("cook_books.visibilities.#{key}"), key] }
  end

  def set_cook_book
    @cook_book = policy_scope(CookBook).find(params[:id])
  end

  def cook_book_params
    params.require(:cook_book).permit(:title, :visibility)
  end
end
