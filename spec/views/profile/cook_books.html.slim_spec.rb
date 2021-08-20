require "rails_helper"

RSpec.describe "profile/cook_books", type: :view do
  include Pagy::Backend
  let(:user) { create(:user) }

  context "when user is not signed in" do
    before do
      visit cook_books_profile_index_path
    end

    it { expect(current_path).to eql(new_user_session_path) }
  end

  context "when user hasn't created any cook books yet" do
    before do
      @pagy, @cook_books = pagy_array(user.cook_books, items: 12)
      assign(:recipes, @recipes)
      assign(:pagy, @pagy)
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit cook_books_profile_index_path
      render
    end

    it { expect(current_path).to eql(cook_books_profile_index_path) }
    it { expect(rendered).to have_tag("a.current", text: t("profile.sidebar.cook_books")) }
  end
end
