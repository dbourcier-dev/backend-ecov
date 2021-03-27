module Mutations
  class CreateDriverRideMutation < Mutations::BaseMutation
    description "A driver declares he will drive trhough a ride"

    argument :user_id, ID, "The id of the driver", required: true
    argument :ride_id, ID, "The id of the ride", required: true

    field :driver_ride, Types::DriverRideType, "The created driver ride", null: true
    field :errors, [String], "The list of errors if it failed. Empty if succeed.", null: true

    ##
    # Attach a driver to a given ride
    #
    # @param user_id  [ID] the id of the driver.
    # @param ride_id [ID] the id of the ride.
    #
    # @return [Hash] a hash containing the created driver ride.
    #
    def resolve(user_id:, ride_id:)
      driver_ride = DriverRide.new(user_id: user_id, ride_id: ride_id)
      if driver_ride.save
        {
          driver_ride: driver_ride,
          errors: []
        }
      else
        {
          passenger_ride: nil,
          errors: passenger_ride.errors.full_messages
        }
      end
    end
  end
end
