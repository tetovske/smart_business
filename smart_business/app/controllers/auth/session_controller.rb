module Auth
  class SessionController < JsonApiController

    AUTH_PARAMS = [:login, :password, :password_confirmation, :phone, :email]

    def signup
      required_params
      render json: { "Hello": "World!" }
    end

    def signin

    end

    def signout

    end

    private

    def required_params
      params.permit(AUTH_PARAMS)
    end
  end
end
