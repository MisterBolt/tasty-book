require "rails_helper"

RSpec.describe CookBooksController, type: :controller do
  def post_create_action(title: "Title", visibility: :public, favourite: false)
    post :create, params: {cook_book: {title: title, visibility: visibility, favourite: favourite}}
  end
  let(:user) { create(:user) }

  describe "GET #index" do
    def get_index_action(page: 1, per_page: 12)
      get :index, params: {page: page, per_page: per_page}
    end
    let(:cook_books) { assigns(:cook_books) }
    let(:pagy) { assigns(:pagy) }
    before { create_list(:cook_book, 13, visibility: "public", favourite: false) }

    context "when page = 1, per_page = 12 and cook_books.size = 13" do
      before { get_index_action(page: 1, per_page: 12) }

      it { expect(response.status).to eq(200) }
      it { expect(cook_books.size).to eq(12) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(2) }
      it { expect(pagy.count).to eq(13) }
      it { expect(pagy.from).to eq(1) }
      it { expect(pagy.to).to eq(12) }
      it { expect(pagy.next).to eq(2) }
      it { expect(pagy.prev).to eq(nil) }
    end

    context "when page = 1, per_page = 15 and cook_books.size = 13" do
      before { get_index_action(page: 1, per_page: 15) }

      it { expect(cook_books.size).to eq(13) }
      it { expect(pagy.pages).to eq(1) }
      it { expect(pagy.from).to eq(1) }
      it { expect(pagy.to).to eq(13) }
      it { expect(pagy.prev).to eq(nil) }
      it { expect(pagy.next).to eq(nil) }
    end
  end

  describe "POST #create" do
    context "when user isn't signed in" do
      it { expect(-> { post_create_action }).not_to change { CookBook.count } }

      it "redirects to login page" do
        post_create_action
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in user adds cook book with right input" do
      before { sign_in user }

      it { expect(-> { post_create_action }).to change { CookBook.count }.by(1) }

      it "displays notice flash message" do
        post_create_action
        expect(flash[:notice]).to eq(I18n.t(".cook_books.create.notice"))
      end
    end

    context "when signed in user adds cook book with wrong input" do
      before { sign_in user }

      it { expect(-> { post_create_action(title: nil) }).not_to change { CookBook.count } }
      it { expect(-> { post_create_action(visibility: nil) }).not_to change { CookBook.count } }

      it "doesn't let changing the favourite flag" do
        post_create_action(favourite: true, title: "Fake favourites")
        expect(CookBook.where(title: "Fake favourites").first.favourite).to eq(false)
      end

      it "display alert flash message" do
        post_create_action(title: nil)
        should set_flash[:alert]
      end
    end
  end
end
