module Advertisements
  class AdvertController < ApplicationController
    before_action :authenticate_user, only: [:create]

    def create
      render json: {
          "hello": "world!"
      }
    end

    def show_all
      render json: {
          "hello": "world!"
      }
    end
  end
end