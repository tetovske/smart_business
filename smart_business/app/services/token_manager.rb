class TokenManager < Service
  include Dry::Monads[:result, :do]

  SECRET_KEY = 'hg34gkhgr34khwer2kerhwe'
  ALGORITHM = 'HS256'

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

  def in_black_list?(token)
    return true unless find_by(token: token).nil?

    false
  end

  def check_token(token)
    token = restore_jwt_token(token)
    Other::JwtDecoder.call.decode_key(token).bind do |data|
      exp = data['expires'].to_time
      return true if (exp - Time.now).positive? && !BlackList.in_black_list?(token)

      return false
    end
    false
  end

  def destroy_token(token)
    token = restore_jwt_token(token)
    BlackList.find_or_create_by(token: token)
  end

  def generate_token(email)
    data = {
        user_email: email,
        expires: Time.now + 1.hours.to_i
    }
    Other::JwtDecoder.call.encode_key(data).value!
  end

  def find_by_token(token)
    token = restore_jwt_token(token)
    Other::JwtDecoder.call.decode_key(token).bind do |val|
      return User.find_by(email: val['user_email'])
    end
  end

  def restore_jwt_token(token)
    "eyJhbGciOiJIUzI1NiJ9.#{token}"
  end
end