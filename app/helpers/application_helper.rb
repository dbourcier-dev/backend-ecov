module ApplicationHelper

  ##
  # Get the network for the current request
  #
  # @return the current network
  def current_network
    current_network_name = request.headers["HTTP_X_CURRENT_NETWORK"]
    return missing_header unless current_network_name
    Network.find_by_name(current_network_name)
  end

  private

  def missing_header
    raise ArgumentError, "Missing value for X_CURRENT_NETWORK header"
  end
end
