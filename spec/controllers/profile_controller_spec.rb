require "rails_helper"

RSpec.describe ProfileController, type: :controller do
  let!(:user) { create(:user, username: "oldUsername", password: "password") }

  describe "GET #index" do
    def get_index_action
      get :index
    end

    context "when user isn't signed in" do
      before { get_index_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when user has default statistics" do
      before do
        sign_in user
        get_index_action
      end
      let(:statistics) { assigns(:statistics) }

      it { expect(statistics.followers).to eq(0) }
      it { expect(statistics.following).to eq(0) }
      it { expect(statistics.user_comments).to eq(0) }
      it { expect(statistics.comments_for_user).to eq(0) }
      it { expect(statistics.user_recipes_in_cook_books).to eq(0) }
      it { expect(statistics.recipes).to eq(0) }
      it { expect(statistics.recipe_drafts).to eq(0) }
      it { expect(statistics.recipes_average_score).to eq(0) }
      it { expect(statistics.cook_books).to eq(1) }
    end

    context "when user increases his statistics" do
      before do
        sign_in user
        create_list(:follow, 3, followed_user: user)
        create(:follow, follower: user)
        create(:comment, user: user)
        recipe = create(:recipe, user: user)
        other_recipe = create(:recipe, user: user)
        create(:comment, recipe: recipe)
        create(:recipe_score, recipe: recipe, score: 4)
        create(:recipe_score, recipe: other_recipe, score: 2)
        cook_book = create(:cook_book, user: user)
        cook_book.recipes << recipe
        get_index_action
      end
      let(:statistics) { assigns(:statistics) }

      it { expect(statistics.followers).to eq(3) }
      it { expect(statistics.following).to eq(1) }
      it { expect(statistics.user_comments).to eq(1) }
      it { expect(statistics.comments_for_user).to eq(1) }
      it { expect(statistics.user_recipes_in_cook_books).to eq(1) }
      it { expect(statistics.recipes).to eq(2) }
      it { expect(statistics.recipes_average_score).to eq(3) }
      it { expect(statistics.cook_books).to eq(2) }
      # TODO: recipes_draft test
    end
  end

  describe "GET #settings" do
    def get_settings_action
      get :settings
    end

    context "when user isn't signed in" do
      before { get_settings_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when user is signed in" do
      before do
        sign_in user
        get_settings_action
      end
      let(:minimum_password_length) { assigns(:minimum_password_length) }

      it { expect(response).not_to redirect_to(new_user_session_path) }
      it { expect(minimum_password_length).to eq(User.password_length.min) }
    end
  end

  describe "PATCH #update_username" do
    def patch_update_username_action(username)
      get :update_username, params: {user: {username: username}}
    end

    context "when user isn't signed in" do
      before { patch_update_username_action("newUsername") }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when logged in user changes his username" do
      before do
        sign_in user
        patch_update_username_action("newUsername")
      end

      it { expect(response).not_to redirect_to(new_user_session_path) }
      it { expect(flash[:notice]).to eq(I18n.t("profile.update_username.notice")) }
      it { expect(user.reload.username).to eq("newUsername") }
    end

    context "when logged in user tries to change username with invalid data" do
      let(:other_user) { create(:user, username: "otherUser") }
      before do
        sign_in user
        patch_update_username_action("  ")
      end

      it { expect(flash[:notice]).not_to be_present }
      it { expect(flash[:alert]).to be_present }
      it { expect(user.reload.username).to eq("oldUsername") }
    end
  end

  describe "PATCH #update_password" do
    def patch_update_password_action(password, password_confirmation, current_password)
      get :update_password, params: {user: {
        password: password,
        password_confirmation: password_confirmation,
        current_password: current_password
      }}
    end

    context "when user isn't signed in" do
      before { patch_update_password_action("123456", "123456", "password") }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when logged in user succesfully changes password" do
      before do
        sign_in user
        patch_update_password_action("123456", "123456", "password")
      end

      it { expect(flash[:notice]).to eq(I18n.t("profile.update_password.notice")) }
      it { expect(user.reload.valid_password?("123456")).to be(true) }
    end

    context "when logged in user tries to change password with invalid data" do
      before { sign_in user }

      it "displays an alert flash message" do
        patch_update_password_action("abcdefg", "123456", "badpassword")
        expect(flash[:alert]).to be_present
      end

      it "doesn't change password when password and password_confirmation doesn't match" do
        expect(-> { patch_update_password_action("123456789", "123456", "password") })
          .not_to change { User.find_by(id: user.id).valid_password?("password") }
      end

      it "doesn't change password when current_password is wrong" do
        expect(-> { patch_update_password_action("123456", "123456", "false_password") })
          .not_to change { User.find_by(id: user.id).valid_password?("password") }
      end

      it "doesn't change password when new password is too short" do
        expect(-> { patch_update_password_action("123", "123", "password") })
          .not_to change { User.find_by(id: user.id).valid_password?("password") }
      end
    end
  end

  describe "GET #cook_books" do
    def get_cook_books_action(page: 1, items: 12)
      get :cook_books, params: {page: page, items: items}
    end
    let(:cook_books) { assigns(:cook_books) }
    let(:pagy) { assigns(:pagy) }
    before do
      create_list(:cook_book, 10, user: user)
      create_list(:cook_book, 5)
    end

    context "when user isn't signed in" do
      before { get_cook_books_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when page = 1, items = 8 and user created 10 new cook books" do
      before do
        sign_in user
        get_cook_books_action(page: 1, items: 8)
      end

      it { expect(cook_books.size).to eq(8) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(2) }
    end

    context "when page = 1, items = 15 and user created 10 new cook books" do
      before do
        sign_in user
        get_cook_books_action(page: 1, items: 15)
      end

      it { expect(cook_books.size).to eq(11) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(1) }
    end
  end

  describe "GET #recipes" do
    def get_recipes_action(page: 1, items: 12)
      get :recipes, params: {page: page, items: items}
    end
    let(:recipes) { assigns(:recipes) }
    let(:pagy) { assigns(:pagy) }
    before do
      create_list(:recipe, 10, status: :published, user: user)
      create_list(:recipe, 2, status: :draft, user: user)
      create_list(:recipe, 5)
    end

    context "when user isn't signed in" do
      before { get_recipes_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when page = 1, items = 8 and user created 10 new recipes" do
      before do
        sign_in user
        get_recipes_action(page: 1, items: 8)
      end

      it { expect(recipes.size).to eq(8) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(2) }
    end

    context "when page = 1, items = 15 and user created 10 new recipes" do
      before do
        sign_in user
        get_recipes_action(page: 1, items: 15)
      end

      it { expect(recipes.size).to eq(10) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(1) }
    end
  end

  describe "GET #recipe_drafts" do
    def get_recipe_drafts_action(page: 1, items: 12)
      get :recipe_drafts, params: {page: page, items: items}
    end
    let(:recipes) { assigns(:recipes) }
    let(:pagy) { assigns(:pagy) }
    before do
      create_list(:recipe, 10, status: :draft, user: user)
      create_list(:recipe, 2, status: :published, user: user)
      create_list(:recipe, 5)
    end

    context "when user isn't signed in" do
      before { get_recipe_drafts_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when page = 1, items = 8 and user created 10 new recipes" do
      before do
        sign_in user
        get_recipe_drafts_action(page: 1, items: 8)
      end

      it { expect(recipes.size).to eq(8) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(2) }
    end

    context "when page = 1, items = 15 and user created 10 new recipes" do
      before do
        sign_in user
        get_recipe_drafts_action(page: 1, items: 15)
      end

      it { expect(recipes.size).to eq(10) }
      it { expect(pagy.page).to eq(1) }
      it { expect(pagy.pages).to eq(1) }
    end
  end

  describe "DELETE #delete_user_with_data" do
    def delete_user_with_data
      delete :delete_user_with_data
    end

    context "when user isn't signed in" do
      it "does not delete user from database" do
        expect(-> { delete_user_with_data }).not_to change { User.count }
      end

      it "redirects to login page" do
        delete_user_with_data
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      let(:user2) { create(:user) }
      let(:recipe) { create(:recipe, user: user2) }
      before do
        user.avatar.attach(io: File.open(Rails.root.join("spec", "files", "avatar.png")), filename: "avatar.png", content_type: "image/png")
        create(:recipe, user: user)
        create(:cook_book, user: user)
        create(:recipe_score, user: user, recipe: recipe)
        create(:follow, follower_id: user.id, followed_user_id: user2.id)
        create(:follow, follower_id: user2.id, followed_user_id: user.id)
        create(:comment, user: user, recipe: recipe)
        sign_in user
        delete_user_with_data
      end

      it "deletes user and all his data from database" do
        expect(User.count).to eq(1)
        expect(ActiveStorage::Attachment.count).to eq(0)
        expect(Recipe.count).to eq(1)
        expect(CookBook.count).to eq(1)
        expect(RecipeScore.count).to eq(0)
        expect(Follow.count).to eq(0)
        expect(Comment.count).to eq(0)
      end

      it "redirects to landing page" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #disable_user_and_keep_data" do
    def patch_disable_user_and_keep_data
      patch :disable_user_and_keep_data
    end

    context "when user isn't signed in" do
      it "does not delete user from database" do
        expect(-> { patch_disable_user_and_keep_data }).not_to change { User.count }
      end

      it "redirects to login page" do
        patch_disable_user_and_keep_data
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      let(:user2) { create(:user) }
      let(:recipe) { create(:recipe, user: user2) }
      before do
        user.avatar.attach(io: File.open(Rails.root.join("spec", "files", "avatar.png")), filename: "avatar.png", content_type: "image/png")
        create(:recipe, user: user)
        create(:cook_book, user: user)
        create(:recipe_score, user: user, recipe: recipe)
        create(:follow, follower_id: user.id, followed_user_id: user2.id)
        create(:follow, follower_id: user2.id, followed_user_id: user.id)
        create(:comment, user: user, recipe: recipe)
        sign_in user
        patch_disable_user_and_keep_data
        user.reload
      end

      it "anonymizes user" do
        expect(user.username).to eq("Deleted_user#{user.id}")
        expect(user.email).to eq("deleted_user#{user.id}@deleted.user")
        expect(Devise.mailer.deliveries.count).to eq(0)
        expect(user.avatar.attached?).to eq(false)
      end

      it "keeps all user data in database" do
        expect(Recipe.count).to eq(2)
        expect(CookBook.count).to eq(3)
        expect(RecipeScore.count).to eq(1)
        expect(Follow.count).to eq(2)
        expect(Comment.count).to eq(1)
      end

      it "redirects to landing page" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
