require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }

  describe "POST #create" do
    subject { post :create, params: {recipe_id: recipe.id, comment: {body: body}} }

    context "with valid params" do
      let(:body) { "Test body!" }
      before { sign_in user }

      it { expect { subject }.to change { Comment.count }.by(1) }

      it "responds with http ok status" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "assigns comment to current user" do
        subject
        expect(Comment.last.user).to eq(user)
      end
    end

    context "with invalid params" do
      let(:body) { nil }
      before { sign_in user }

      it { expect { subject }.not_to change { Comment.count } }
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, body: "test", user: user, recipe: recipe) }
    subject { delete :destroy, params: {id: id, recipe_id: recipe.id} }

    context "with valid model" do
      let(:id) { comment.id }
      before do
        sign_in user
        subject
      end

      it "deletes comment" do
        expect(Comment.where(id: comment.id).exists?).to eq(false)
      end

      it "displays notice flash message" do
        expect(flash[:notice]).to eq(I18n.t(".comments.destroy.notice"))
      end

      it "redirects to recipe page" do
        expect(response).to redirect_to(recipe_path(recipe.id))
      end
    end

    context "without existing model" do
      let(:id) { 0 }
      before { sign_in user }

      it "raises an error when id is not valid" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
