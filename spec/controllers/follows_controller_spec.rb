require "rails_helper"

RSpec.describe FollowsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "POST #create" do
    context "when user isn't signed in" do
      it "does not add follow relationship to database" do
        expect do
          post :create, params: {followed_user_id: other_user.id}
        end.not_to change { Follow.count }
      end

      it "redirects to login page" do
        post :create, params: {followed_user_id: other_user.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "adds follow relationship to other user" do
        expect do
          post :create, params: {followed_user_id: other_user.id}
        end.to change { Follow.count }.by(1)
      end

      it "displays notice flash message" do
        post :create, params: {followed_user_id: other_user.id}
        expect(flash[:notice]).to eq(I18n.t("follows.create.notice"))
      end

      it "sends follow notification email" do
        expect do
          post :create, params: {followed_user_id: other_user.id}
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to followed user page" do
        post :create, params: {followed_user_id: other_user.id}
        expect(response).to redirect_to(user_path(other_user))
      end

      it "does not add follow relationship to himself" do
        expect do
          post :create, params: {followed_user_id: user.id}
        end.not_to change { Follow.count }
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user isn't signed in" do
      it "does not delete follow relationship from database" do
        expect do
          delete :destroy, params: {id: other_user.id}
        end.not_to change { Follow.count }
      end

      it "redirects to login page" do
        delete :destroy, params: {id: other_user.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before do
        sign_in user
        post :create, params: {followed_user_id: other_user.id}
      end

      it "removes follow relationship to other user" do
        expect do
          delete :destroy, params: {id: other_user.id}
        end.to change { Follow.count }.by(-1)
      end

      it "displays notice flash message" do
        delete :destroy, params: {id: other_user.id}
        expect(flash[:notice]).to eq(I18n.t("follows.destroy.notice"))
      end

      it "redirects to unfollowed user page" do
        delete :destroy, params: {id: other_user.id}
        expect(response).to redirect_to(user_path(other_user))
      end
    end
  end
end
