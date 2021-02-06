class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles, dependent: :destroy
  has_many :adverts, dependent: :destroy
  scope :admins, -> { joins(:roles).where(roles: { name: Role::ADMIN_ROLE_NAME }) }
  scope :default_users, -> { joins(:roles).where(roles: { name: Role::DEFAULT_USER_ROLE_NAME }) }

  validates :phone, uniqueness: true

  after_create_commit :setup_default_role

  # updates jwt token
  def update_token
    BlackList.destroy_token(jwt_token)
    new_token = BlackList.generate_token(phone)
    update(jwt_token: new_token)
  end

  def setup_default_role
    UserRole.setup_default_role(self)
  end

  def make_admin
    grant_role(Role::ADMIN_ROLE_NAME)
  end

  def make_customer
    grant_role(Role::CUSTOMER_ROLE_NAME)
  end

  def make_perfomer
    grant_role(Role::PERFOMER_ROLE_NAME)
  end

  def revoke_admin
    revoke_role(Role::ADMIN_ROLE_NAME)
  end

  def admin?
    roles.any?(&:admin?)
  end

  private

  def grant_role(role_name)
    UserRole.grant_user_role(self, role_name)
  end

  def revoke_role(role_name)
    UserRole.revoke_user_role(self, role_name)
  end
end
