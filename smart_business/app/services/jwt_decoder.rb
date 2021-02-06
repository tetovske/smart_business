# frozen_string_literal: true

class JwtDecoder < Service
  include Dry::Monads[:result, :do]

  SECRET_KEY = 'fjsldfjlj45ljlq34120werpk2'.freeze
  ALGORITHM = 'HS256'.freeze

  def call
    self
  end

  def encode_key(data)
    return Failure(:arg_isnt_hash) unless data.is_a?(Hash)

    data = JWT.encode data, SECRET_KEY, ALGORITHM
    return Success(data) unless data.nil?

    Failure(:failed_to_create_key)
  end

  def decode_key(token)
    Try { JWT.decode token, SECRET_KEY, ALGORITHM }
        .bind { |data| Success(data.first) }
        .or(Failure(:invalid_token))
  end
end