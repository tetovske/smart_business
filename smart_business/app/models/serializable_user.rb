class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :login, :phone, :email, :registration_date
end