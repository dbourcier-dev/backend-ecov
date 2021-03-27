require "rails_helper"

RSpec.describe "A passenger registers for a given ride", :type => :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => Base64.strict_encode64("Toulouse")} }
  let(:network){ Network.create(name: "Toulouse") }
  let(:passenger){User.create(email: "peter@email.com", network: network)}
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }
  let(:request_params) {
    {
      query: <<-GRAPHQL
        mutation{
          createPassengerRide(
            input: {
              userId: #{passenger.id},
              rideId: #{ride.id}
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
  it "should create a passenger ride with the given information" do
    subject

    expect(PassengerRide.last.user).to eq(passenger)
    expect(PassengerRide.last.ride).to eq(ride)
  end

  context "When the passenger is not from the current network" do
    let(:headers) { {"HTTP_X_CURRENT_NETWORK" => Base64.strict_encode64("Nantes")} }
    before do
      Network.create(name: "Nantes")
    end
    it "should reject the creation of the ride" do
      subject

      expect(response).to be_successful
      result = JSON.parse(response.body)
      expect(result["data"]["createPassengerRide"]).to be_nil
    end
  end


  context "When the ride is not on the current network" do
    let(:nantes) { Network.create(name: "Nantes") }
    let(:ride){ Ride.create(departure: "ici", arrival: "la", network: nantes) }
    it "should reject the creation of the ride" do
      subject

      expect(response).to be_successful
      result = JSON.parse(response.body)
      expect(result["data"]["createPassengerRide"]).to be_nil

    end
  end
end
