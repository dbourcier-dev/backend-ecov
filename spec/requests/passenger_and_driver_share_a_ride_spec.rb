require "rails_helper"

RSpec.describe "Ride sharing between a driver and a passenger", :type => :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => "Toulouse"} }
  let(:network){ Network.create(name: "Toulouse") }
  let(:driver){ User.create(email: "david@email.com", network: network) }
  let(:passenger){User.create(email: "peter@email.com", network: network)}
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }
  let(:driver_ride) { DriverRide.create(user_id: driver.id, ride_id: ride.id) }
  let(:passenger_ride) { PassengerRide.create(user_id: passenger.id, ride_id: ride.id) }
  let(:request_params) {
      {
        query: "mutation{
          shareRide(
            input: {
              driverRideId: #{driver_ride.id},
              passengerRideId: #{passenger_ride.id}
            }
          ){
            passengerRide{
              id
            }
            errors
          }
        }"
      }
    }
  subject { post "/graphql", params: request_params, headers: headers }
  it "should attach the driver to the passenger ride" do
    subject
    expect(PassengerRide.last.driver_ride).to eq(DriverRide.last)
  end
end
