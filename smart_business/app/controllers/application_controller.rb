class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def authenticate_user
    token = request.headers['token']
    return true if !token.blank? && BlackList.check_token(token)

    false
  end
end
