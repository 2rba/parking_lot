# frozen_string_literal: true
require 'spec_helper'

describe ParkingLot do
  subject(:lot) do
    described_class.new(lot_config)
  end

  let(:lot_config) do
    LotConfig.new(
      {
        ['motorcycle', 'scooter'] => 200,
        ['car', 'suv'] => 500
        # busses are skipped as no fee model is defined for them
      },
      {
        ['motorcycle', 'scooter'] => FeeModels::AirportFee.new({
                                                                 0...(1.hour) => 0,
                                                                 (1.hour)...(8.hours) => 40,
                                                                 (8.hours)...(24.hours) => 60
                                                               },
                                                               80),
        ['car', 'suv'] => FeeModels::AirportFee.new({
                                                      0...(12.hours) => 60,
                                                      (12.hours)...(24.hours) => 80
                                                    },
                                                    100)
      }
    )
  end

  example 'example 4' do
    Timecop.freeze

    expect(lot.park('motorcycle')).to include(ticket_number: '001')
    Timecop.freeze(Time.now + 55.minutes)
    expect(lot.unpark('motorcycle', '001')).to include({ fees: 0 })

    expect(lot.park('motorcycle')).to include(ticket_number: '002')
    Timecop.freeze(Time.now + 14.hours + 59.minutes)
    expect(lot.unpark('motorcycle', '002')).to include({ fees: 60 })

    expect(lot.park('motorcycle')).to include(ticket_number: '003')
    Timecop.freeze(Time.now + 1.day + 12.hours)
    expect(lot.unpark('motorcycle', '003')).to include({ fees: 160 })

    expect(lot.park('car')).to include(ticket_number: '004')
    Timecop.freeze(Time.now + 50.minutes)
    expect(lot.unpark('car', '004')).to include({ fees: 60 })

    expect(lot.park('suv')).to include(ticket_number: '005')
    Timecop.freeze(Time.now + 23.hours + 59.minutes)
    expect(lot.unpark('suv', '005')).to include({ fees: 80 })

    expect(lot.park('car')).to include(ticket_number: '006')
    Timecop.freeze(Time.now + 3.days + 1.hour)
    expect(lot.unpark('car', '006')).to include({ fees: 400 })
  end
end
