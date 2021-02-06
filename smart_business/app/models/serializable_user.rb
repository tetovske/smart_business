class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :login, :phone, :email, :registration_date, :city, :birth_date
  attributes :role do
    @object.roles
  end
end