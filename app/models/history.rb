class History < ApplicationRecord
  belongs_to :dish

  validates :dish, presence: true
end
