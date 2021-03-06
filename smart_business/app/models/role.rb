class Role < ApplicationRecord
  DEFAULT_USER_ROLE_NAME = 'user'
  ADMIN_ROLE_NAME = 'admin'
  CUSTOMER_ROLE_NAME = 'customer'
  PERFOMER_ROLE_NAME = 'perfomer'
  ALL_ROLES = %w[user admin perfomer customer].freeze

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  class << self
    def enum_list
      ALL_ROLES
    end

    def default_role
      Role.find_by(name: DEFAULT_USER_ROLE_NAME)
    end
  end
end
