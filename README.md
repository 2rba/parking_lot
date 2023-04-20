# install
tested with ruby 3.2.2
- `git clone git@github.com:2rba/parking_lot.git`
- `cd parking_lot`
- `bundle install`
- for tests: `bundle exec rspec`

tests can be found in `spec` folder\
code can be found in `lib` folder

# decisions
- input to the code is provided either via unit tests
- Timecop is used to simulate time in tests
- Ticket number format and receipt format are guessed based on the example
- no input validation, validation should be performed on the other level


# service classes
- AllocatedSpot holds information about allocation spot, ticket, spot number, times and fee model reference
- Fee model classes(AirportFee, FlatFee, StadiumFee) accepts time and returns fee
- LotConfig holds lot details: capacity, fee model
- SpotManager responsibilities: allocate spot, release spot
- ParkingLog is a kind of controller class which connects other components together, responds on: park, unpark
