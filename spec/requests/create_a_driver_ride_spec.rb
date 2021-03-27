require "rails_helper"

RSpec.describe "Driver register for a given ride", :type => :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => "Toulouse"} }
  let(:network){ Network.create(name: "Toulouse") }
  let(:driver){ User.create(email: "david@email.com", network: network) }
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }
  let(:request_params) {
    {
      query: "mutation{
        createDriverRide(
          input: {
            userId: #{driver.id},
            rideId: #{ride.id}
          }
        ){
          driverRide{
            id
          }
          errors
        }
      }"
    }
  }

  subject { post "/graphql", params: request_params, headers: headers }
  it "should create a ride with the given information" do
    subject

    expect(DriverRide.last.user).to eq(driver)
    expect(DriverRide.last.ride).to eq(ride)
  end
end
