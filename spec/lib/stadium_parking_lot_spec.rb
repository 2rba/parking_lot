# frozen_string_literal: true
require 'spec_helper'

describe ParkingLot do
  subject(:lot) do
    described_class.new(lot_config)
  end

  let(:lot_config) do
    LotConfig.new(
      {
        ['motorcycle', 'scooter'] => 1000,
        ['car', 'suv'] => 1500
      },
      {
        ['motorcycle', 'scooter'] => FeeModels::StadiumFee.new({
                                                                 0...(4.hours) => 30,
                                                                 (4.hours)...(12.hours) => 60
                                                               },
                                                               12.hours,
                                                               100),
        ['car', 'suv'] => FeeModels::StadiumFee.new({
                                                      0...(4.hours) => 60,
                                                      (4.hours)...(12.hours) => 120
                                                    },
                                                    12.hours,
                                                    200)
      }
    )
  end

  example 'example 3' do
    Timecop.freeze

    expect(lot.park('motorcycle')).to include(ticket_number: '001')
    Timecop.freeze(Time.now + 3.hours + 40.minutes)
    expect(lot.unpark('motorcycle', '001')).to include({ fees: 30 })

    expect(lot.park('motorcycle')).to include(ticket_number: '002')
    Timecop.freeze(Time.now + 14.hours + 59.minutes)
    expect(lot.unpark('motorcycle', '002')).to include({ fees: 390 })

    expect(lot.park('suv')).to include(ticket_number: '003')
    Timecop.freeze(Time.now + 11.hours + 30.minutes)
    expect(lot.unpark('suv', '003')).to include({ fees: 180 })

    expect(lot.park('suv')).to include(ticket_number: '004')
    Timecop.freeze(Time.now + 13.hours + 5.minutes)
    expect(lot.unpark('suv', '004')).to include({ fees: 580 })
  end
end
