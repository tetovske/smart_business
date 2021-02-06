class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles, dependent: :destroy
  has_many :adverts, dependent: :destroy
  scope :admins, -> { joins(:roles).where(roles: { name: Role::ADMIN_ROLE_NAME }) }
  scope :default_users, -> { joins(:roles).where(roles: { name: Role::DEFAULT_USER_ROLE_NAME }) }

  after_create_commit :setup_default_role

  def setup_default_role
    UserRole.setup_default_role(self)
  end

  def make_admin
    grant_role(Role::ADMIN_ROLE_NAME)
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
