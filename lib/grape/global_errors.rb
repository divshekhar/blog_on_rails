module Grape::GlobalErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      error!({ message: e.message, error_code: 404 }, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!({ message: e.message, error_code: 400 }, 400)
    end
  end
end