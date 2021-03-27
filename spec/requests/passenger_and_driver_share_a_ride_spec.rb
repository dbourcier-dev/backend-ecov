require "rails_helper"

RSpec.describe "Ride sharing between a driver and a passenger", :type => :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => Base64.strict_encode64("Toulouse")} }
  let(:network){ Network.create(name: "Toulouse") }
  let(:driver){ User.create(email: "david@email.com", network: network) }
  let(:passenger){User.create(email: "peter@email.com", network: network)}
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }
  let(:driver_ride) { DriverRide.create(user_id: driver.id, ride_id: ride.id) }
  let(:passenger_ride) { PassengerRide.create(user_id: passenger.id, ride_id: ride.id) }
  let(:request_params) {
      {
        query:
        <<-GRAPHQL
          mutation{
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
          }
        GRAPHQL
      }
    }

  subject { post "/graphql", params: request_params, headers: headers }
  it "should attach the driver to the passenger ride" do
    subject
    expect(PassengerRide.last.driver_ride).to eq(DriverRide.last)
  end

  context "When the ride is not on the current network" do
    let(:nantes) { Network.create(name: "Nantes") }
    let(:ride){Ride.create(departure: "ici", arrival: "la", network: nantes) }

    it "should not perform the mutation" do
      subject

      expect(response).to be_successful
      result = JSON.parse(response.body)
      expect(result["data"]["shareRide"]).to be_nil
    end
  end
end
