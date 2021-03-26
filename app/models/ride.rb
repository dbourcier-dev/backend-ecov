class Ride < ApplicationRecord
  has_many :driver_rides
  has_many :passenger_rides
  belongs_to  :network

  validates :departure, :arrival, presence: true
end
