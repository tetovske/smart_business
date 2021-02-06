class JsonApiController < ApplicationController
  extend ActiveSupport::Concern

  included do
    include ActionController::Cookies

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  private

  def serializer_options
    {}
  end

  def render_serialized(data, meta: {}, status: :ok)
    render jsonapi: data,
           include: %i[user expert],
           fields: serializer_options.fetch(:fields) { {} },
           expose: serializer_options.fetch(:expose) { {} },
           status: status,
           meta: meta
  end

  def render_not_found
    render json: {
        errors: [
            {
                title: 'Not found',
                status: 404
            }
        ]
    }, status: :not_found
  end

  def render_error(messages:)
    render json: {
        errors: Array.wrap(messages)
    }, status: :unprocessable_entity
  end

  def render_unauthorized
    render json: {
        errors: [
            {
                title: 'Unauthorized',
                status: 401
            }
        ],
        loginUrl: jwt_init_url,
        logoutUrl: jwt_logout_url
    }, status: :unauthorized
  end
end