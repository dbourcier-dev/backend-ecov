require "rails_helper"

RSpec.describe "A passenger registers for a given ride", :type => :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => "Toulouse"} }
  let(:network){ Network.create(name: "Toulouse") }
  let(:passenger){User.create(email: "peter@email.com", network: network)}
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }
  let(:request_params) {
    {
      query: "mutation{
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
      }"
    }
  }
  subject { post "/graphql", params: request_params, headers: headers }
  it "creates a Widget and redirects to the Widget's page" do
    subject

    expect(PassengerRide.last.user).to eq(passenger)
    expect(PassengerRide.last.ride).to eq(ride)
  end
end
