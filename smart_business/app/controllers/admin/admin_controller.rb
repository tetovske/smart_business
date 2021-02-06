module Admin
  class AdminController < ApplicationController
    deserializable_resource :user, only: %i[grant_user]
    deserializable_resource :advert, only: %i[change_advertisement]

    PATCH_USER_PARAMS = %i[roles]
    PATCH_ADVERT_PARAMS = %i[roles]

    def grant_user
      User::Update.call(patch_user_params).either(
          ->(user) { render_serialized user.value!, status: :ok },
          ->(error) { render_error messages: error }
      )
    end

    def change_advertisement
      Advert::Update.call(patch_user_params).either(
          ->(advert) { render_serialized advert.value!, status: :ok },
          ->(error) { render_error messages: error }
      )
    end

    def patch_user_params
      params.require(:user).permit(PATCH_USER_PARAMS)
    end

    def patch_advert_params
      params.require(:advert).permit(PATCH_ADVERT_PARAMS)
    end
  end
end