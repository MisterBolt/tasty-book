require "rails_helper"

RSpec.describe CookBooksController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    def get_index_action(page: 1, items: 12)
      get :index, params: {page: page, items: items}
    end
    let(:cook_books) { assigns(:cook_books) }
    let(:pagy) { assigns(:pagy) }

    context "when page = 1, items = 12 and cook_books.size = 13" do
      before do
        create_list(:cook_book, 13, visibility: "public", favourite: false)
        get_index_action(page: 1, items: 12)
      end

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

    context "when page = 1, items = 15 and cook_books.size = 13" do
      before do
        create_list(:cook_book, 13, visibility: "public", favourite: false)
        get_index_action(page: 1, items: 15)
      end

      it { expect(cook_books.size).to eq(13) }
      it { expect(pagy.pages).to eq(1) }
      it { expect(pagy.from).to eq(1) }
      it { expect(pagy.to).to eq(13) }
      it { expect(pagy.prev).to eq(nil) }
      it { expect(pagy.next).to eq(nil) }
    end

    context "when cook_books have different visibilities" do
      before do
        sign_in user
        other_user = create(:user)
        create(:follow, follower_id: user.id, followed_user_id: other_user.id)
        create(:cook_book, visibility: "public", favourite: false)
        create(:cook_book, visibility: "private", favourite: false)
        create(:cook_book, visibility: "private", favourite: false, user: other_user)
        create(:cook_book, visibility: "followers", favourite: false)
        create(:cook_book, visibility: "followers", favourite: false, user: user)
        create(:cook_book, visibility: "followers", favourite: false, user: other_user)
        get_index_action(page: 1, items: 15)
      end

      it { expect(cook_books.pluck(:visibility)).not_to include("private") }
      it { expect(cook_books.pluck(:visibility).uniq).to contain_exactly("public", "followers") }
      it { expect(cook_books.count).to eq(3) }
    end
  end

  describe "POST #create" do
    def post_create_action(title: "Title", visibility: :public, favourite: false)
      post :create, params: {cook_book: {title: title, visibility: visibility, favourite: favourite}}
    end

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

  describe "DELETE #destroy" do
    def delete_destroy_action(cook_book)
      delete :destroy, params: {id: cook_book.id}
    end
    before { sign_in user }

    context "when user is the owner of the cook book" do
      let!(:cook_book) { create(:cook_book, user: user) }

      it { expect(-> { delete_destroy_action(cook_book) }).to change { CookBook.count }.by(-1) }
    end

    context "when user isn't the owner of the cook book that's out of his scope" do
      let!(:cook_book) { create(:cook_book, visibility: :private) }

      it { expect(-> { delete_destroy_action(cook_book) }).to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when user isn't the owner of the cook book that's in his scope" do
      let!(:cook_book) { create(:cook_book, visibility: :public) }

      it { expect(-> { delete_destroy_action(cook_book) }).to raise_error(Pundit::NotAuthorizedError) }
    end
  end
end
