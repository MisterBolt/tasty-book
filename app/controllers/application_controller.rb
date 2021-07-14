class ApplicationController < ActionController::Base
    before_action :configure_sign_up_params, only: [:create, :update]
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :terms, :location])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :terms, :location])
    end

    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
end
