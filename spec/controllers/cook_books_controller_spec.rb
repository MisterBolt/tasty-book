require "rails_helper"

RSpec.describe CookBooksController, type: :controller do
  def posting(title: "Title", visibility: :public, favourite: false)
    post :create, params: {cook_book: {title: title, visibility: visibility, favourite: favourite}}
  end
  let(:user) { create(:user) }

  describe "POST #create" do
    context "when user isn't signed in" do
      it { expect(-> { posting }).not_to change { CookBook.count } }

      it "redirects to login page" do
        posting
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in user adds cook book with right input" do
      before { sign_in user }

      it { expect(-> { posting }).to change { CookBook.count }.by(1) }

      it "displays notice flash message" do
        posting
        expect(flash[:notice]).to eq(I18n.t(".cook_books.create.notice"))
      end
    end

    context "when signed in user adds cook book with wrong input" do
      before { sign_in user }

      it { expect(-> { posting(title: nil) }).not_to change { CookBook.count } }
      it { expect(-> { posting(visibility: nil) }).not_to change { CookBook.count } }

      it "doesn't let changing the favourite flag" do
        posting(favourite: true, title: "Fake favourites")
        expect(CookBook.where(title: "Fake favourites").first.favourite).to eq(false)
      end

      it "display alert flash message" do
        posting(title: nil)
        should set_flash[:alert]
      end
    end
  end
end
