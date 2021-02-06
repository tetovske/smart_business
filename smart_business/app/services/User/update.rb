# frozen_string_literal: true

module Adverts
  class Patch < Basics::BaseInteractor
    extend Dry::Initializer
    include Dry::Monads[:try, :result, :do, :maybe]

    REQUIRE_PARAMS = %w[id].freeze

    param :json_params, proc(&:to_h)

    def call
      yield params_presence
      yield check_req_params
      params = yield convert_date
      user = yield find_user
      upd_user = yield update_model(user, params.except(:id))

      Success(upd_user)
    end

    private

    def params_presence
      Maybe(json_params).to_result.or Failure(:empty_params)
    end

    def check_req_params
      REQUIRE_PARAMS.all? { |p| json_params.key?(p) } ? Success() : Failure(:require_params_missed)
    end

    def convert_date
      converter.call(json_params).either(
          ->(conv_params) { Success(conv_params) },
          -> { Success(json_params) }
      )
    end

    def find_user
      Success(User.where(id: json_params[:id]))
    end

    def append_attributes(model, params)
      model.assign_attributes(params)
      Success(model)
    end

    def validate_attributes(model)
      model.valid? ? Success(model) : Failure(model.errors)
    end

    def update_model(model, params)
      Try { model.update(params) ? Success(model) : Failure(:cant_update_model) }
          .to_result
          .or Failure(:failed_to_update)
    end
  end
end