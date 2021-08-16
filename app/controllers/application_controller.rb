class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend
  DEFAULT_PER_PAGE = 12
  DEFAULT_SORT_KIND = "title"
  DEFAULT_SORT_ORDER = "ASC"
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_user_params, only: [:create, :update], if: :devise_controller?

  def require_admin
    authenticate_user!
    redirect_to new_user_session_path unless current_user.admin?
  end

  protected

  def configure_user_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end

  private

  def per_page
    params[:items].presence || DEFAULT_PER_PAGE
  end

  def sort_kind
    params[:kind].presence || DEFAULT_SORT_KIND
  end

  def sort_order
    params[:order].presence || DEFAULT_SORT_ORDER
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
