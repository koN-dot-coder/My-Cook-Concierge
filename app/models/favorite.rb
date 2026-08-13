class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :dish

  validates :dish_id, uniqueness: { scope: :user_id }
end
