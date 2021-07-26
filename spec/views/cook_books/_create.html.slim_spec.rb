require "rails_helper"

RSpec.describe "cook_books/_create", type: :view do
  let(:user) { create(:user) }
  let(:cook_book) { CookBook.new }
  let(:visibilities) { CookBook.visibilities.map { |key, value| [key.humanize, key] } }
  before do
    assign(:cook_book, cook_book)
    assign(:visibilities, visibilities)
  end

  context "with unsigned user" do
    before { render }

    it "doesn't display the modal button" do
      expect(rendered).not_to match /button/
    end

    it "doesn't display the modal" do
      expect(rendered).not_to match /modal/
    end
  end

  context "with user signed in" do
    before do
      sign_in user
      render
    end

    it "displays the modal button" do
      expect(rendered).to match /create_cook_book/
    end

    it "displays modal in hidden mode" do
      expect(rendered).to match /modal hidden/
    end
  end
end
