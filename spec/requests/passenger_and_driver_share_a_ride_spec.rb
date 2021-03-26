require "rails_helper"

RSpec.describe "Ride sharing between a driver and a passenger", :type => :request do
  let(:network){ Network.create(name: "Toulouse") }
  let(:driver){ User.create(email: "david@email.com", network: network) }
  let(:passenger){User.create(email: "peter@email.com", network: network)}
  let(:ride){Ride.create(departure: "ici", arrival: "la", network: network) }

  it "creates a Widget and redirects to the Widget's page" do
    post "/graphql", params: {
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

    expect(DriverRide.last.user).to eq(driver)
    expect(DriverRide.last.ride).to eq(ride)

    post "/graphql", params: {
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

    expect(PassengerRide.last.user).to eq(passenger)
    expect(PassengerRide.last.ride).to eq(ride)

    post "/graphql", params: {
      query: "mutation{
        shareRide(
          input: {
          	driverRideId: #{DriverRide.last.id},
          	passengerRideId: #{PassengerRide.last.id}
        	}
        ){
          passengerRide{
            id
          }
          errors
        }
      }"
    }

    p response.body
    expect(PassengerRide.last.driver_ride).to eq(DriverRide.last)
  end
end
