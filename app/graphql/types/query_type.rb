module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false, description: "An user"

    ##
    # Get the full list of users.
    # The list is filtered based on the current network provided
    # in the execution context
    #
    # @return [User[]]a collection of users.
    def users
      User.where(network_id: context[:current_network].id)
    end
  end
end
