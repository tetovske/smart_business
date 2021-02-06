class Comment < ApplicationRecord
  belongs_to :adverts
  belongs_to :user
end
