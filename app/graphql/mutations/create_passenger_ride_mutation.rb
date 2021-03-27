module Mutations
  class CreatePassengerRideMutation < Mutations::BaseMutation
    description "A passenger requests a ride"

    argument :user_id, ID, "The id of the passenger", required: true
    argument :ride_id, ID, "The id of the ride", required: true

    field :passenger_ride, Types::PassengerRideType, "The created passenger ride", null: true
    field :errors, [String], "The list of errors if it failed. Empty if succeed.", null: true

    ##
    # Create a passanger ride.
    #
    # @param user_id [ID] the id of the passenger.
    # @param ride_id [ID] the id of the ride.
    #
    # @return [Hash] a hash containing the created pasenger ride.
    def resolve(user_id:, ride_id:)
      passenger_ride = PassengerRide.new(user_id: user_id, ride_id: ride_id)
      if passenger_ride.save
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
