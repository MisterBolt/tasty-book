require "rails_helper"
require "pundit/rspec"

RSpec.describe "profile/cook_books", type: :view do
  include Pagy::Backend
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context "when user is not signed in" do
    before { visit cook_books_profile_index_path }

    it { expect(current_path).to eql(new_user_session_path) }
  end

  context "when user hasn't created any cook books yet" do
    before do
      @pagy, @cook_books = pagy_array(user.cook_books, items: 12)
      assign(:cook_books, user.cook_books)
      assign(:pagy, @pagy)
      assign(:visibilities, CookBook.visibilities_strings)
      sign_in user
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit cook_books_profile_index_path
      render
    end

    it { expect(current_path).to eql(cook_books_profile_index_path) }
    it { expect(rendered).to have_tag("a.current", text: t("profile.sidebar.cook_books")) }
    it { expect(rendered).to have_tag("button.btn-secondary", text: t("cook_books.create.action")) }
    it { expect(rendered).to have_tag("article.cook-book", count: 1) }
    it { expect(rendered).to have_tag("div.drop-menu") }
    it { expect(rendered).to have_text(t("cook_books.edit.action")) }
    it { expect(rendered).not_to have_text(t("cook_books.destroy.action")) }
  end

  context "with 13 cook books" do
    before do
      create_list(:cook_book, 13, user: user)
      pagy, cook_books = pagy_array(user.cook_books, items: 12)
      assign(:cook_books, cook_books)
      assign(:pagy, pagy)
      assign(:visibilities, CookBook.visibilities_strings)
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

  context "with different visibilities of cook books" do
    before do
      create(:cook_book, visibility: :public)
      create(:cook_book, visibility: :public, user: other_user)
      create(:cook_book, visibility: :public, user: user)
      create(:cook_book, visibility: :followers)
      create(:cook_book, visibility: :followers, user: other_user)
      create(:cook_book, visibility: :followers, user: user)
      create(:cook_book, visibility: :private)
      create(:cook_book, visibility: :private, user: other_user)
      create(:cook_book, visibility: :private, user: user)
      sign_in user
      user.follow(other_user)
      pagy, cook_books = pagy_array(user.cook_books, items: 12)
      assign(:cook_books, cook_books)
      assign(:pagy, pagy)
      assign(:visibilities, CookBook.visibilities_strings)
      render
    end

    it { expect(rendered).to have_tag("article.cook-book") { without_tag("svg", count: 1) } }
    it { expect(rendered).to have_tag("article.cook-book", count: 4) }
    it { expect(rendered).to have_tag("article.cook-book", text: user.username) { with_tag(".cook_book_private_svg", count: 2) } }
    it { expect(rendered).to have_tag("article.cook-book", text: user.username) { with_tag(".cook_book_followers_svg", count: 1) } }
  end
end
