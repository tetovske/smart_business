module Advertisements
  class AdvertController < ApplicationController
    before_action :authenticate_user, only: [:create, :show_my]

    deserializable_resource :advert, only: %i[change_advertisement]

    def create
      Advert::Create.call(ads_params).either(
          ->(advert) { render_serialized advert.value!, status: :ok },
          ->(error) { render_error messages: error }
      )
    end

    def show_all
      render_serialized Adverts.all
    end

    def show_my
      user_ads_list = User.where(jwt_token: request.headers['token'])
      render_serialized user_ads_list
    end

    def ads_params
      params.require(:advert).permit!
    end
  end
end