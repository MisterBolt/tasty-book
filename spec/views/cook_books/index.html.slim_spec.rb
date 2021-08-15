require "rails_helper"

RSpec.describe "cook_books/index", type: :view do
  include Pagy::Backend
  let(:user) { create(:user) }

  context "with no cook books" do
    before do
      @cook_books = create_list(:cook_book, 0, visibility: "public", favourite: false)
      @pagy, @cook_books = pagy_array(@cook_books, items: 12)
      assign(:cook_books, @cook_books)
      assign(:pagy, @pagy)
      render
    end

    it { expect(rendered).not_to have_tag("article.cook-book") }
    it { expect(rendered).not_to have_tag("nav.pagy-nav") }
    it { expect(rendered).to have_text(I18n.t("cook_books.not_found")) }
  end

  context "with 4 cook book with different amount of recipes" do
    before do
      @cook_books = create_list(:cook_book, 4)
      4.times do |i|
        @cook_books[i].recipes = create_list(:recipe, i)
      end
      @pagy, @cook_books = pagy_array(@cook_books, items: 12)
      assign(:cook_books, @cook_books)
      assign(:pagy, @pagy)
      render
    end

    it { expect(rendered).not_to have_tag("nav.pagy-nav") }
    it { expect(rendered).to have_tag("article.cook-book") { with_tag("img", count: 6) } }
    it { expect(rendered).to have_tag("article.cook-book", count: 4) }
    it { expect(rendered).to have_tag("article.cook-book", text: I18n.t("recipes.not_found")) }
    it { expect(rendered).to have_tag("article.cook-book", text: @cook_books[1].recipes[0].title) }
    it {
      expect(rendered).to have_tag(
        "article.cook-book",
        text: @cook_books[2].recipes.map { |recipe| recipe.title }.join(", ")
      )
    }
    it {
      expect(rendered).to have_tag(
        "article.cook-book",
        text: @cook_books[3].recipes.map { |recipe| recipe.title }.join(", ")
      )
    }
  end

  context "with 13 cook book" do
    before do
      @cook_books = create_list(:cook_book, 13)
      @pagy, @cook_books = pagy_array(@cook_books, items: 12)
      assign(:cook_books, @cook_books)
      assign(:pagy, @pagy)
      render
    end

    it { expect(rendered).to have_tag("article.cook-book", count: 12) }
    it "displays a pagination navbar" do
      expect(rendered).to have_tag("nav.pagy-nav") do
        with_tag("span.prev", with: {class: "disabled"})
        with_tag("span.next", without: {class: "disabled"})
        with_tag("span.active", text: "1")
        with_tag("span", text: "2")
        without_tag("span", text: "3")
      end
    end
  end
end
