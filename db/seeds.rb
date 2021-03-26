# We flush the DB
PassengerRide.delete_all
DriverRide.delete_all
Ride.delete_all
User.delete_all

# We start by creating some rides,
# These are the available routes our users will be able to use
toulouse_intra = Ride.new(departure: "Cite de l'espace", arrival: "Capitole")


Ride.create([
  {departure: "Capitole", arrival: "Aeroport"},
  {departure: "Louvre", arrival: "Nation"},
  {departure: "Clichy", arrival: "Louvre"}
])
# Now, some users have signed up to our platform
# David, with a "D" as in "Driver"
david = User.new(email: "david@email.com")

# Patrice, with a "P" as in "Passenger"
patrice = User.new(email: "patrice@email.com")

# Peter, with a "P" as in "Passenger"
peter = User.new(email: "peter@email.com")

# Next, our users start to use our transport service
# David inform us that he will drive his car on the toulouse_intra route
david_ride = DriverRide.new(user: david, ride: toulouse_intra)

# And at the same time, Patrice made a passenger request on the same route
patrice_ride = PassengerRide.new(user: patrice, ride: toulouse_intra)

# So both of them meet, and David invites Patrice to share the ride
patrice_ride.update(driver_ride: david_ride)

# At the last time, Peter also make a request for the same route
peter_ride = PassengerRide.new(user: peter, ride: toulouse_intra)

# So David can also take him in his car, he now has two passenger, and his car is almost full.
# So much co2 saved compared to if the three of them had used their own car
peter_ride.update(driver_ride: david_ride)
