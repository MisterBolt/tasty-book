# frozen_string_literal: true

class CookBooks < ApplicationController
  def index
    @cook_books = CookBook.all
  end
end
