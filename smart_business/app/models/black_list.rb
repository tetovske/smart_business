class BlackList < ApplicationRecord
  def in_black_list?(token)
    return true unless find_by(token: token).nil?

    false
  end

  def check_token(token)
    token = restore_jwt_token(token)
    JwtDecoder.call.decode_key(token).bind do |data|
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
    JwtDecoder.call.encode_key(data).value!
  end

  def find_by_token(token)
    token = restore_jwt_token(token)
    JwtDecoder.call.decode_key(token).bind do |val|
      return User.find_by(phone: val['phone'])
    end
  end

  def restore_jwt_token(token)
    "eyJhbGciOiJIUzI1NiJ9.#{token}"
  end
end
