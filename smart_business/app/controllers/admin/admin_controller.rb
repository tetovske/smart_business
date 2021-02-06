module Admin
  class AdminController < ApplicationController
    deserializable_resource :user, only: %i[grant_user patch]

    PATCH_USER_PARAMS = %i[roles]

    def grant_user
      User::Update.call(patch_user_params).either(
          ->(booking) { render_serialized booking.value!, status: :ok },
          ->(error) { render_error messages: error }
      )
    end

    def patch_user_params
      params.require(:user).permit(PATCH_USER_PARAMS)
    end
  end
end