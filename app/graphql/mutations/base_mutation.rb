module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    UNAUTHORIZED_NETWORK = "This operation is not authorized on the current network".freeze
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    ##
    # The operation is authorized only if the user end the ride
    # are from the current network.
    #
    def authorized_network!(ride_id:, user_id:)
      (user_on_network?(user_id: user_id) && ride_on_network?(ride_id: ride_id)) || unauthorized!
    end

    def network_id
      context[:current_network]&.id
    end

    private

    ##
    # Is the requested ride on the current network ?
    #
    # @param rideId [ID] the requested ride.
    #
    # @return [Boolean] true if on the same network, false otherwize.
    #
    def ride_on_network?(ride_id:)
      ride = Ride.find(ride_id)
      ride&.network&.id == network_id
    end

    ##
    # Is the user from the current network ?
    #
    # @param userId [ID] the user id.
    #
    # @return [Boolean] true if on the same network, false otherwize.
    #
    def user_on_network?(user_id:)
      user = User.find(user_id)
      user&.network&.id == network_id
    end

    def unauthorized!
      raise GraphQL::ExecutionError, UNAUTHORIZED_NETWORK
    end
  end
end
