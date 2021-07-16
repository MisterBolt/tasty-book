class ApplicationController < ActionController::Base
  include Pagy::Backend
  DEFAULT_PER_PAGE = 10
  before_action :configure_user_params, only: [:create, :update], if: :devise_controller?

  def require_user
      redirect_to new_user_session_path unless current_user
  end

  def require_admin
      redirect_to new_user_session_path unless current_user.admin?
  end

  protected

  def configure_user_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def per_page
    params[:per_page].presence || DEFAULT_PER_PAGE
  end
end
