module Advert
  class Update < Service
    include Dry::Monads[:try, :result, :do, :maybe]

    REQUIRE_PARAMS = %w[id].freeze

    param :json_params, proc(&:to_h)

    def call
      yield params_presence
      yield check_req_params
      advert = yield find_advert
      upd_advert = yield update_model(advert, params.except(:id))

      Success(upd_advert)
    end

    private

    def params_presence
      Maybe(json_params).to_result.or Failure(:empty_params)
    end

    def check_req_params
      REQUIRE_PARAMS.all? { |p| json_params.key?(p) } ? Success() : Failure(:require_params_missed)
    end

    def find_advert
      Success(Advert.where(id: json_params[:id]))
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