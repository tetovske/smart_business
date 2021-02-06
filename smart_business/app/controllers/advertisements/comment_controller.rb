module Advertisemets
  class CommentController < ApplicationController
    include JsonApiController

    deserializable_resource :comment, only: %i[create_comment update_comment delete_comment]

    PATCH_USER_PARAMS = %i[roles]
    PATCH_ADVERT_PARAMS = %i[roles]

    def create_comment
      Comment::Create.call(patch_user_params).either(
          ->(user) { render_serialized user.value!, status: :ok },
          ->(error) { render_error messages: error }
      )
    end

    def update_comment
      Comment::Update.call(patch_user_params).either(
          ->(advert) { render_serialized advert.value!, status: :ok },
          ->(error) { render_error messages: error }
      )
    end
  end
end