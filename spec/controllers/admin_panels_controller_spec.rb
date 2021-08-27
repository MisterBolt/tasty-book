require "rails_helper"

RSpec.describe AdminPanelsController, type: :controller do
  let(:user) { create(:user, admin: false) }
  let(:admin) { create(:user, admin: true) }

  describe "GET #show" do
    def get_show_action
      get :show
    end

    context "when visiting as guest" do
      before { get_show_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when visiting as regular user" do
      before do
        sign_in user
        get_show_action
      end

      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "GET #comments" do
    def get_comments_action
      get :comments
    end

    context "when visiting as guest" do
      before { get_comments_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when visiting as regular user" do
      before do
        sign_in user
        get_comments_action
      end

      it { expect(response).to redirect_to(root_path) }
    end

    context "when visiting as admin" do
      let(:comments) { assigns(:comments) }
      before do
        sign_in admin
        create_list(:comment, 4, status: :awaiting)
        create_list(:comment, 6, status: :approved)
        create_list(:comment, 2, status: :rejected)
        get_comments_action
      end

      it { expect(comments.size).to eq(4) }
    end
  end

  describe "patch #comment_approve" do
    let!(:comment) { create(:comment, status: :awaiting) }
    def patch_comment_approve_action(comment)
      patch :comment_approve, params: {id: comment.id}
    end

    context "when updating comment as guest" do
      before { patch_comment_approve_action(comment) }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when updating comment as regular user" do
      before do
        sign_in user
        patch_comment_approve_action(comment)
      end

      it { expect(response).to redirect_to(root_path) }
    end

    context "when updating comment as admin" do
      before { sign_in admin }

      it { expect(-> { patch_comment_approve_action(comment) }).to change { Comment.awaiting.count }.by(-1) }
      it { expect(-> { patch_comment_approve_action(comment) }).to change { Comment.approved.count }.by(1) }
    end
  end

  describe "patch #comment_reject" do
    let!(:comment) { create(:comment, status: :awaiting) }
    def patch_comment_reject_action(comment)
      patch :comment_reject, params: {id: comment.id}
    end

    context "when updating comment as guest" do
      before { patch_comment_reject_action(comment) }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when updating comment as regular user" do
      before do
        sign_in user
        patch_comment_reject_action(comment)
      end

      it { expect(response).to redirect_to(root_path) }
    end

    context "when updating comment as admin" do
      before { sign_in admin }

      it { expect(-> { patch_comment_reject_action(comment) }).to change { Comment.awaiting.count }.by(-1) }
      it { expect(-> { patch_comment_reject_action(comment) }).to change { Comment.rejected.count }.by(1) }
    end
  end
end
