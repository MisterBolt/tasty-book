require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    def get_index_action(page: 1, items: 10, kind: "title", order: "ASC")
      get :index, params: {page: page, items: items, filters: {kind: kind, order: order}}
    end
    let(:recipes_raw) do
      [
        create(:recipe, title: "TitleF", difficulty: "EASY", time_in_minutes_needed: 29),
        create(:recipe, title: "TitleG", difficulty: "EASY", time_in_minutes_needed: 29),
        create(:recipe, title: "TitleH", difficulty: "MEDIUM", time_in_minutes_needed: 12),
        create(:recipe, title: "TitleI", difficulty: "MEDIUM", time_in_minutes_needed: 7),
        create(:recipe, title: "TitleA", difficulty: "HARD", time_in_minutes_needed: 10),
        create(:recipe, title: "TitleB", difficulty: "HARD", time_in_minutes_needed: 19),
        create(:recipe, title: "TitleC", difficulty: "HARD", time_in_minutes_needed: 19),
        create(:recipe, title: "TitleD", difficulty: "HARD", time_in_minutes_needed: 19),
        create(:recipe, title: "TitleE", difficulty: "HARD", time_in_minutes_needed: 29),
        create(:recipe, title: "TitleJ", difficulty: "MEDIUM", time_in_minutes_needed: 10),
        create(:recipe, title: "TitleK", difficulty: "MEDIUM", time_in_minutes_needed: 6),
        create(:recipe, title: "TitleL", difficulty: "MEDIUM", time_in_minutes_needed: 11)
      ]
    end
    let(:recipes) { assigns(:recipes) }
    let(:pagy) { assigns(:pagy) }
    before do
      8.times do |i|
        create(:recipe_score, recipe: recipes_raw[i], score: (i % 5) + 1)
      end
    end

    context "when page = 1, items = 10 and recipes.length = 12" do
      before { get_index_action(page: 1, items: 10) }

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

    context "when page = 1, items = 15 and recipes.length = 12" do
      before { get_index_action(page: 1, items: 15) }

      it { expect(recipes.length).to eq(12) }
      it { expect(pagy.pages).to eq(1) }
      it { expect(pagy.from).to eq(1) }
      it { expect(pagy.to).to eq(12) }
      it { expect(pagy.prev).to eq(nil) }
      it { expect(pagy.next).to eq(nil) }
    end

    context "when page = 2, items = 5 and recipes.length = 12" do
      before { get_index_action(page: 2, items: 5) }

      it { expect(recipes.length).to eq(5) }
      it { expect(pagy.page).to eq(2) }
      it { expect(pagy.pages).to eq(3) }
      it { expect(pagy.next).to eq(3) }
      it { expect(pagy.prev).to eq(1) }
    end

    context "when kind: title, order: ASC" do
      before { get_index_action }
      subject { recipes.map(&:title) }

      it { expect(subject).to eq(("A".."J").map { |letter| "Title#{letter}" }) }
    end

    context "when kind: title, order: DESC" do
      before { get_index_action(order: "DESC") }
      subject { recipes.map(&:title) }

      it { expect(subject).to eq(("C".."L").to_a.reverse.map { |letter| "Title#{letter}" }) }
    end

    context "when kind: difficulty, order: DESC" do
      before { get_index_action(kind: "difficulty", order: "DESC") }
      subject { recipes.map(&:difficulty) }

      it { expect(subject).to eq(["HARD"] * 5 + ["MEDIUM"] * 5) }
    end

    context "when kind: time_in_minutes_needed, order: DESC" do
      before { get_index_action(kind: "time_in_minutes_needed", order: "DESC") }
      subject { recipes.map(&:time_in_minutes_needed) }

      it { expect(subject).to eq([29, 29, 29, 19, 19, 19, 12, 11, 10, 10]) }
    end

    context "when kind: score, order: DESC" do
      before { get_index_action(kind: "score", order: "DESC") }
      subject { recipes.map(&:average_score) }

      it { expect(subject).to eq([5.0, 4.0, 3.0, 3.0, 2.0, 2.0, 1.0, 1.0, 0.0, 0.0]) }
    end

    context "when kind: score, order: ASC" do
      before { get_index_action(kind: "score", order: "ASC") }
      subject { recipes.map(&:average_score) }

      it { expect(subject).to eq([0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 2.0, 3.0, 3.0]) }
    end
  end

  describe "PATCH #update_cook_books" do
    def patch_update_action(cook_book_ids: [""])
      patch :update_cook_books, params: {use_route: "recipes/:id/", id: recipe.id, recipe: {cook_book_ids: cook_book_ids}}
    end
    let(:recipe) { create(:recipe) }
    before { create_list(:cook_book, 3, user: user) }

    context "when user is not signed in" do
      before { patch_update_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when signed in user add recipe to his own cook books" do
      before { sign_in user }

      it { expect(-> { patch_update_action }).not_to change { recipe.cook_books.count } }
      it { expect(-> { patch_update_action(cook_book_ids: user.cook_books.ids) }).to change { recipe.cook_books.count }.by(user.cook_books.count) }
      it { expect(-> { patch_update_action(cook_book_ids: user.cook_books.ids[0..1]) }).to change { recipe.cook_books.count }.by(2) }
      it { expect(-> { patch_update_action(cook_book_ids: [user.cook_books.ids[0]]) }).to change { user.cook_books[0].recipes.count }.by(1) }
      it { expect(-> { patch_update_action }).not_to change { recipe.cook_books.count } }

      it "displays notice flash message" do
        patch_update_action
        expect(flash[:notice]).to eq(I18n.t(".recipes.update_cook_books.notice"))
      end
    end

    context "when signed in user add recipe to someone else's cook books" do
      let(:user2) { create(:user) }
      before do
        create_list(:cook_book, 3, user: user2)
        sign_in user
      end

      it { expect(-> { patch_update_action(cook_book_ids: user2.cook_books.ids) }).not_to change { recipe.cook_books.count } }
      it { expect(-> { patch_update_action(cook_book_ids: [user2.cook_books.ids[0]]) }).not_to change { user2.cook_books[0].recipes.count } }
      it { expect(-> { patch_update_action(cook_book_ids: [user.cook_books.ids[0], user2.cook_books.ids[0]]) }).not_to change { user2.cook_books[0].recipes.count } }

      it "displays alert flash message" do
        patch_update_action(cook_book_ids: user2.cook_books.ids)
        expect(flash[:alert]).to eq(I18n.t(".recipes.update_cook_books.alert"))
      end
    end

    context "when two users add same recipe to their cook books" do
      let(:user2) { create(:user) }
      before { create_list(:cook_book, 3, user: user2) }
      subject do
        -> do
          sign_in user
          patch_update_action(cook_book_ids: user.cook_books.ids)
          sign_out user
          sign_in user2
          patch_update_action(cook_book_ids: user2.cook_books.ids)
        end
      end

      it { expect(subject).to change { recipe.cook_books.count }.by(user.cook_books.count + user2.cook_books.count) }
    end
  end

  describe "PATCH #update_favourite" do
    def patch_update_action
      patch :update_favourite, params: {use_route: "recipes/:id/", id: recipe.id}
    end
    let(:recipe) { create(:recipe) }

    context "when user is not signed in" do
      before { patch_update_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when user is signed in" do
      before { sign_in user }

      context "and adding recipe to favourites" do
        it { expect(-> { patch_update_action }).to change { user.cook_books[0].recipes.count }.by(1) }

        it "displays notice flash message" do
          patch_update_action
          expect(flash[:notice]).to eq(I18n.t(".recipes.update_favourite.notice"))
        end
      end

      context "and removing recipe from favourites" do
        before { patch_update_action }

        it { expect(-> { patch_update_action }).to change { user.cook_books[0].recipes.count }.by(-1) }

        it "displays notice flash message" do
          patch_update_action
          expect(flash[:notice]).to eq(I18n.t(".recipes.update_favourite.notice"))
        end
      end
    end
  end
end
