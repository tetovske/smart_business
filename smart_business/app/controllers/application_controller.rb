class ApplicationController < ActionController::Base
  include JsonApiController
  skip_before_action :verify_authenticity_token

  def authenticate_user
    token = request.headers['token']
    return true if !token.blank? && BlackList.check_token(token)

    render_error messages: 'unauthorized'
  end
end
