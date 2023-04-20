# frozen_string_literal: true
class ParkingLot
  TIME_FORMAT = '%d-%b-%Y %H:%M:%S'
  def initialize(lot_config)
    @lot_config = lot_config
    @sequential_ticket_number = 0
    @sequential_receipt_number = 0
  end

  def park(vehicle_type)
    fee_model = get_fee_model(vehicle_type)
    allocated_spot = spot_manager(vehicle_type).allocate_spot(method(:get_ticket_number), fee_model)
    {
      ticket_number: allocated_spot.ticket_number,
      spot_number: allocated_spot.spot_number,
      entry_time: allocated_spot.entry_time.strftime(TIME_FORMAT)
    }
  rescue Errors::NoFreeSpotsError
    {
      message: 'No space available'
    }
  end

  def unpark(vehicle_type, ticket_number)
    spot_manager = spot_manager(vehicle_type)
    allocated_spot = spot_manager.release_spot(ticket_number)
    fee_model = allocated_spot.fee_model
    fees = fee_model.calculate(allocated_spot.exit_time - allocated_spot.entry_time)
    {
      receipt_number: get_receipt_number,
      entry_time: allocated_spot.entry_time.strftime(TIME_FORMAT),
      exit_time: allocated_spot.exit_time.strftime(TIME_FORMAT),
      fees: fees
    }
  end

  private

  def spot_manager(vehicle_type)
    @lot_config.spot_manager(vehicle_type)
  end

  def get_fee_model(vehicle_type)
    @lot_config.fee_model(vehicle_type)
  end

  # vulnerable to race conditions, mutex required in concurrent environments
  # could be extracted to a separate class
  def get_ticket_number
    @sequential_ticket_number += 1
    format('%03d', @sequential_ticket_number) # formated in the same style as in the example
  end

  # vulnerable to race conditions, mutex required in concurrent environments
  # could be extracted to a separate class
  def get_receipt_number
    @sequential_receipt_number += 1
    "R-#{format('%03d', @sequential_receipt_number)}" # formated in the same style as in the example
  end
end
