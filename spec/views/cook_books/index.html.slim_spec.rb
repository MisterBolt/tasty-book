require "rails_helper"

RSpec.describe "cook_books/index", type: :view do
  include Pagy::Backend
  let(:user) { create(:user) }

  context "with no cook books" do
    before do
      cook_books = create_list(:cook_book, 0, visibility: :public, favourite: false)
      pagy, cook_books = pagy_array(cook_books, items: 12)
      assign(:cook_books, cook_books)
      assign(:pagy, pagy)
      render
    end

    it { expect(rendered).not_to have_tag("article.cook-book") }
    it { expect(rendered).not_to have_tag("nav.pagy-nav") }
    it { expect(rendered).to have_text(I18n.t("cook_books.not_found")) }
  end

  context "with 4 cook book with different amount of recipes" do
    let(:cook_books) { create_list(:cook_book, 4) }
    before do
      4.times do |i|
        cook_books[i].recipes = create_list(:recipe, i)
      end
      pagy, cook_books_pagy = pagy_array(cook_books, items: 12)
      cook_books = cook_books_pagy
      assign(:cook_books, cook_books)
      assign(:pagy, pagy)
      render
    end

    it { expect(rendered).to have_tag("article.cook-book") { with_tag("img", count: 6) } }
    it { expect(rendered).to have_tag("article.cook-book", count: 4) }
    it { expect(rendered).to have_tag("article.cook-book", text: cook_books[0].title) }
    it { expect(rendered).to have_tag("article.cook-book", text: I18n.t("recipes.not_found")) }
    it { expect(rendered).to have_tag("article.cook-book", text: cook_books[1].recipes[0].title) }
    it {
      expect(rendered).to have_tag(
        "article.cook-book",
        text: cook_books[2].recipes.map { |recipe| recipe.title }.join(", ")
      )
    }
    it {
      expect(rendered).to have_tag(
        "article.cook-book",
        text: cook_books[3].recipes.map { |recipe| recipe.title }.join(", ")
      )
    }
  end

  context "with 13 cook books" do
    before do
      cook_books = create_list(:cook_book, 13)
      pagy, cook_books = pagy_array(cook_books, items: 12)
      assign(:cook_books, cook_books)
      assign(:pagy, pagy)
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

  context "when user isn't owner of listed cook_book" do
    before do
      sign_in user
      cook_books = create_list(:cook_book, 1, visibility: :public, favourite: false)
      pagy, cook_books = pagy_array(cook_books, items: 12)
      assign(:cook_books, cook_books)
      assign(:visibilities, CookBook.visibilities_strings)
      assign(:pagy, pagy)
      render
    end

    it { expect(rendered).not_to have_tag("div.drop-menu") }
    it { expect(rendered).not_to have_text(t("cook_books.edit.action")) }
    it { expect(rendered).not_to have_text(t("cook_books.destroy.action")) }
  end

  context "when user is owner of listed cook_book" do
    before do
      sign_in user
      cook_books = create_list(:cook_book, 1, user: user, visibility: :public, favourite: false)
      pagy, cook_books = pagy_array(cook_books, items: 12)
      assign(:cook_books, cook_books)
      assign(:visibilities, CookBook.visibilities_strings)
      assign(:pagy, pagy)
      render
    end

    it { expect(rendered).to have_tag("div.drop-menu") }
    it { expect(rendered).to have_text(t("cook_books.edit.action")) }
    it { expect(rendered).to have_text(t("cook_books.destroy.action")) }
  end
end
