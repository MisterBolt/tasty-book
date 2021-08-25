require "rails_helper"

RSpec.describe "profile/_create_cook_book", type: :view do
  let(:user) { create(:user) }
  let(:cook_book) { CookBook.new }
  let(:visibilities) { CookBook.visibilities.map { |key, value| [t("cook_books.visibilities.#{key}"), key] } }
  before do
    assign(:cook_book, cook_book)
    assign(:visibilities, visibilities)
  end

  context "when user isn't signed in" do
    before { visit recipes_profile_index_path }

    it { expect(current_path).to eql(new_user_session_path) }
  end

  context "when user is signed in" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit cook_books_profile_index_path
    end

    it { expect(current_path).to eql(cook_books_profile_index_path) }
    it { expect(page).to have_css("#create_cook_book.hidden") }
    it "displays the modal after clicking on the create cook book button" do
      find("button", text: t("cook_books.create.action")).click
      expect(rendered).not_to have_css("#create_cook_book.hidden")
    end
    it { expect(page).to have_css("input#cook_book_title[type='text'][placeholder='#{t("cook_books.form.title_placeholder")}']") }
    it { expect(page).to have_css("select#cook_book_visibility") }
    it { expect(page).to have_css("option[value='public']") }
    it { expect(page).to have_css("option[value='private']") }
    it { expect(page).to have_css("option[value='followers']") }
  end
end
