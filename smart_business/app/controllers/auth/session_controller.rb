module Auth
  class SessionController < ApplicationController
    include JsonApiController
    include Dry::Monads[:try, :result, :do, :maybe]

    before_action :authenticate_user, only: [:user_info]

    AUTH_PARAMS = [:login, :password, :phone, :email, :birth_date, :city]

    def signup
      required_params
      par = params[:_jsonapi]
      if check_params(par)
        user = User.create(par)
        user.update(jwt_token: BlackList.generate_token(user.phone), registration_date: DateTime.now)
        render json: {
            status: 'authenticated',
            token: user.jwt_token
        }
      else
        render_error messages: 'error_while_signup'
      end
    end

    def signin
      required_params
      par = params[:_jsonapi]
      if check_params(par)
        user = User.find_by(phone: par['phone'], password: par['password'])
        if user
          user.update_token
          render json: {
              status: 'authenticated',
              token: user.jwt_token
          }
        else
          render_error messages: 'unknown user'
        end
      else
        render_error messages: 'invalid params'
      end
    end

    def signout
      token = request.headers['token']
      if !token.blank?
        BlackList.destroy_token(token)
        render json: { message: 'token successfully destroyed!' }
      else
        render json: { message: 'invalid params!' }
      end
    end

    def user_info
      token = params.head
    end

    private

    def check_params(params)
      params.keys.all? { |par| AUTH_PARAMS.include?(par.to_sym) }
    end

    def required_params
      params.require(:_jsonapi).permit!
    end
  end
end
