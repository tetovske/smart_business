# frozen_string_literal: true

module Adverts
  class Create < Basics::BaseInteractor
    extend Dry::Initializer
    include Dry::Monads[:try, :result, :do, :maybe]

    REQUIRE_PARAMS = %w[expert_id].freeze

    param :json_params, proc(&:to_h)

    def call
      yield params_presence
      yield check_req_params
      params = yield convert_date
      booking = yield build
      booking = yield append_attributes(booking, params)
      yield validate_attributes(booking)
      saved_booking = yield save_model(booking)

      Success(saved_booking)
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
          ->(err) { Success(json_params) }
      )
    end

    def build
      Success(Booking.new)
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