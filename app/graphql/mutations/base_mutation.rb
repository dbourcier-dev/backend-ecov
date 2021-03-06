module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    UNAUTHORIZED_NETWORK = "This operation is not authorized on the current network".freeze
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    protected

    ##
    # The operation is authorized only if the user end the ride
    # are from the current network.
    #
    # @raise [GraphQL::ExecutionError] raised when the user  or the
    # given ride is not part of the current network
    #
    def authorized_network!(ride_id:, user_id:)
      (user_on_network?(user_id: user_id) && ride_on_network?(ride_id: ride_id)) || forbiden!
    end

    ##
    # To be used when the asked operation is not authorized.
    #
    def forbiden!
      raise GraphQL::ExecutionError, UNAUTHORIZED_NETWORK
    end

    ##
    # Get the network id from the execution context.
    #
    # @return [ID] the current network Id.
    #
    def same_network?(network_id:)
      network_id == context[:current_network]&.id
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
      same_network?(network_id: ride&.network&.id)
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
      same_network?(network_id: user&.network&.id)
    end
  end
end
