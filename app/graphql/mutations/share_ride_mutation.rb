module Mutations
  class ShareRideMutation < Mutations::BaseMutation
    description "A passenger goes with a driver"

    argument :driver_ride_id, ID, "The id of the driver ride", required: true
    argument :passenger_ride_id, ID, "The id of the passenger ride", required: true

    field :passenger_ride, Types::PassengerRideType, "The updated passenger ride", null: true
    field :errors, [String], "The list of errors if it failed. Empty if succeed.", null: true

    ##
    # Attach a passenger ride to a driver ride
    #
    # @param passenger_ride_id [ID] a passenger ride Id.
    # @param driver_ride_id [ID] a driver ride Id.
    #
    # @return [Hash] a hash containing the passenger ride.
    #
    def resolve(passenger_ride_id:, driver_ride_id:)
      passenger_ride = PassengerRide.find(passenger_ride_id)

      if passenger_ride.update(driver_ride_id: driver_ride_id)
        {
          passenger_ride: passenger_ride,
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
