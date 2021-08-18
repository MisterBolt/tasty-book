module Api::Concerns::ErrorSerializer
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {status: "NOT_FOUND", message: e.message}, status: :not_found
    end
  end
end
