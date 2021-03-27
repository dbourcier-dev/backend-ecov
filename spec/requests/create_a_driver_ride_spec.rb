require "rails_helper"

RSpec.describe "Driver register for a given ride", :type => :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => "Toulouse"} }
  let(:network){ Network.create(name: "Toulouse") }
  let(:driver){ User.create(email: "david@email.com", network: network) }
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }
  let(:request_params) {
    {
      query: <<-GRAPHQL
        mutation{
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
        }
      GRAPHQL
    }
  }

  subject { post "/graphql", params: request_params, headers: headers }
  it "should create a ride with the given information" do
    subject

    expect(DriverRide.last.user).to eq(driver)
    expect(DriverRide.last.ride).to eq(ride)
  end

  context "When the user is not from the current network" do
    let(:headers) { {"HTTP_X_CURRENT_NETWORK" => "Nantes"} }
    before do
      Network.create(name: "Nantes")
    end
    it "should reject the creation of the ride" do
      subject

      expect(response).to be_successful
      result = JSON.parse(response.body)
      expect(result["data"]["createDriverRide"]).to be_nil
    end
  end

  context "When the ride is not on the current network" do
    let(:nantes) { Network.create(name: "Nantes") }
    let(:ride){ Ride.create(departure: "ici", arrival: "la", network: nantes) }
    it "should reject the creation of the ride" do
      subject

      expect(response).to be_successful
      result = JSON.parse(response.body)
      expect(result["data"]["createDriverRide"]).to be_nil

    end
  end
end
