# frozen_string_literal: true
require 'spec_helper'

describe ParkingLot do
  subject(:lot) do
    described_class.new(lot_config)
  end

  let(:lot_config) do
    LotConfig.new(
      {
        ['motorcycle', 'scooter'] => 100,
        ['car', 'suv'] => 80,
        ['bus', 'truck'] => 10
      },
      {
        ['motorcycle', 'scooter'] => FeeModels::FlatFee.new(10),
        ['car', 'suv'] => FeeModels::FlatFee.new(20),
        ['bus', 'truck'] => FeeModels::FlatFee.new(50)
      }
    )
  end

  example 'example 2' do
    Timecop.freeze

    expect(lot.park('motorcycle')).to include(ticket_number: '001')
    Timecop.freeze(Time.now + 3.hours + 30.minutes)
    expect(lot.unpark('motorcycle', '001')).to include({ fees: 40 })

    expect(lot.park('car')).to include(ticket_number: '002')
    Timecop.freeze(Time.now + 6.hours + 1.minute)
    expect(lot.unpark('car', '002')).to include({ fees: 140 })

    expect(lot.park('truck')).to include(ticket_number: '003')
    Timecop.freeze(Time.now + 1.hour + 59.minutes)
    expect(lot.unpark('truck', '003')).to include({ fees: 100 })
  end
end
