module ApplicationHelper
  CURRENT_NETWORK_HEADER = "HTTP_X_CURRENT_NETWORK".freeze
  MISSING_HEADER_MESSAGE = "Missing value for X_CURRENT_NETWORK header".freeze
  UNKNOWN_NETWORK_MESSAGE = "Unknown network provided".freeze

  ##
  # Get the network for the current request
  #
  # @return the current network
  # @raise [ArgumentError] when there is no current network provided
  # or when the network is unknown.
  #
  def current_network
    encoded_network_name = request.headers[CURRENT_NETWORK_HEADER]
    raise_error(MISSING_HEADER_MESSAGE) unless encoded_network_name

    current_network_name = Base64.strict_decode64(encoded_network_name)
    network = Network.find_by_name(current_network_name)
    raise_error(UNKNOWN_NETWORK_MESSAGE) unless network

    network
  end

  private

  def raise_error(message)
    raise ArgumentError, message
  end
end
