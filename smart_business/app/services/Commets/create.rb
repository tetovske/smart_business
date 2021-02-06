# frozen_string_literal: true

module Comment
  class Create < Basics::BaseInteractor
    extend Dry::Initializer
    include Dry::Monads[:try, :result, :do, :maybe]

    REQUIRE_PARAMS = %w[].freeze

    param :json_params, proc(&:to_h)

    def call
      yield params_presence
      yield check_req_params
      comment = yield build
      comment = yield append_attributes(comment, params)
      yield validate_attributes(comment)
      saved_comment = yield save_model(comment)

      Success(saved_comment)
    end

    private

    def params_presence
      Maybe(json_params).to_result.or Failure(:empty_params)
    end

    def check_req_params
      REQUIRE_PARAMS.all? { |p| json_params.key?(p) } ? Success() : Failure(:require_params_missed)
    end

    def build
      Success(Comment.new)
    end

    def append_attributes(model, params)
      model.assign_attributes(params)
      Success(model)
    end

    def validate_attributes(model)
      model.valid? ? Success(model) : Failure(model.errors)
    end

    def save_model(model)
      Try { model.save ? Success(model) : Failure(:cant_save_model) }
          .to_result
          .or Failure(:booking_already_exists)
    end
  end
end