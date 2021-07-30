require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    def getting(page: 1, per_page: 10)
      get :index, params: {page: page, per_page: per_page}
    end
    let(:recipes) { assigns(:recipes) }
    let(:pagy) { assigns(:pagy) }
    before { create_list(:recipe, 12) }

    context "when page = 1, per_page = 10 and recipes.length = 12" do
      before { getting(page: 1, per_page: 10) }

      it { expect(response.status).to eq(200) }
      it { expect(recipes.length).to eq(10) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(2) }
      it { expect(pagy.count).to eq(12) }
      it { expect(pagy.from).to eq(1) }
      it { expect(pagy.to).to eq(10) }
      it { expect(pagy.next).to eq(2) }
      it { expect(pagy.prev).to eq(nil) }
    end

    context "when page = 1, per_page = 15 and recipes.length = 12" do
      before { getting(page: 1, per_page: 15) }

      it { expect(recipes.length).to eq(12) }
      it { expect(pagy.pages).to eq(1) }
      it { expect(pagy.from).to eq(1) }
      it { expect(pagy.to).to eq(12) }
      it { expect(pagy.prev).to eq(nil) }
      it { expect(pagy.next).to eq(nil) }
    end

    context "when page = 2, per_page = 5 and recipes.length = 12" do
      before { getting(page: 2, per_page: 5) }

      it { expect(recipes.length).to eq(5) }
      it { expect(pagy.page).to eq(2) }
      it { expect(pagy.pages).to eq(3) }
      it { expect(pagy.next).to eq(3) }
      it { expect(pagy.prev).to eq(1) }
    end
  end

  describe "PATCH #update_cook_books" do
    def patching(cook_book_ids: [""])
      patch :update_cook_books, params: {use_route: "recipes/:id/", id: recipe.id, recipe: {cook_book_ids: cook_book_ids}}
    end
    let(:recipe) { create(:recipe) }
    before { create_list(:cook_book, 3, user: user) }

    context "user is not signed in" do
      before { patching }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when signed in user add recipe to his own cook books" do
      before { sign_in user }

      it { expect(-> { patching(cook_book_ids: user.cook_books.ids) }).to change { recipe.cook_books.count }.by(user.cook_books.count) }
      it { expect(-> { patching(cook_book_ids: user.cook_books.ids[0..1]) }).to change { recipe.cook_books.count }.by(2) }
      it { expect(-> { patching(cook_book_ids: [user.cook_books.ids[0]]) }).to change { user.cook_books[0].recipes.count }.by(1) }
      it { expect(-> { patching }).not_to change { recipe.cook_books.count } }

      it "displays notice flash message" do
        patching
        expect(flash[:notice]).to eq(I18n.t(".recipes.update_cook_books.notice"))
      end
    end

    context "when signed in user add recipe to someone else's cook books" do
      let(:user2) { create(:user) }
      before do
        create_list(:cook_book, 3, user: user2)
        sign_in user
      end

      it { expect(-> { patching(cook_book_ids: user2.cook_books.ids) }).not_to change { recipe.cook_books.count } }
      it { expect(-> { patching(cook_book_ids: [user2.cook_books.ids[0]]) }).not_to change { user2.cook_books[0].recipes.count } }

      it "displays alert flash message" do
        patching(cook_book_ids: user2.cook_books.ids)
        expect(flash[:alert]).to eq(I18n.t(".recipes.update_cook_books.alert"))
      end
    end
  end
end
