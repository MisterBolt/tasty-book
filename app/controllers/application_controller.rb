class ApplicationController < ActionController::Base
    before_action :configure_user_params, only: [:create, :update], if: :devise_controller?

    protected

    def configure_user_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
end
