class Network < ApplicationRecord
  has_many :users
  has_many :rides

  validates :name, presence: true
end
