# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# frozen_string_literal: true

require 'faker'

# Generating default roles
Role.enum_list.each { |role_name| Role.create name: role_name }

# Generate random users
10.times do
  user = User.create(uid: Faker::Number.number(digits: 10))
  user.make_admin if [true, false].sample
end
