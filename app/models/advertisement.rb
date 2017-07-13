class Advertisement < ApplicationRecord
  validates :title, :body, :price, presence: true
end
