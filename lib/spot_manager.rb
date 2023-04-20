# frozen_string_literal: true
class SpotManager
  def initialize(capacity)
    @capacity = capacity
    @allocations = {}
  end

  # vulnerable to race conditions, mutex required in concurrent environments
  def allocate_spot(ticket_number_getter, fee_model)
    occupied_spots = @allocations.values.map(&:spot_number)
    free_spot_number = ((1..@capacity).to_a - occupied_spots).min
    raise Errors::NoFreeSpotsError unless free_spot_number

    ticket_number = ticket_number_getter.call
    allocation = AllocatedSpot.new(
      ticket_number: ticket_number,
      spot_number: free_spot_number,
      entry_time: Time.now,
      fee_model: fee_model # stored to simplify price change process
    )
    @allocations[ticket_number] = allocation
    allocation
  end

  # vulnerable to race conditions, mutex required in concurrent environments
  def release_spot(ticket_number)
    raise 'unknown ticket number' unless @allocations.key? ticket_number

    allocation = @allocations.delete ticket_number
    allocation.exit_time = Time.now
    allocation
  end
end
