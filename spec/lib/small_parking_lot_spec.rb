# frozen_string_literal: true
require 'spec_helper'

describe ParkingLot do
  subject(:lot) do
    described_class.new(lot_config)
  end

  let(:lot_config) do
    LotConfig.new(
      { ['motorcycle', 'scooter'] => 2 },
      { ['motorcycle', 'scooter'] => FeeModels::FlatFee.new(10) }
    )
  end

  example 'example 1' do
    Timecop.freeze('29-May-2022 14:04:07')
    expect(lot.park('motorcycle')).to eq({
                                           ticket_number: '001',
                                           spot_number: 1,
                                           entry_time: '29-May-2022 14:04:07'
                                         })
    Timecop.freeze('29-May-2022 14:44:07')
    expect(lot.park('scooter')).to eq({
                                        ticket_number: '002',
                                        spot_number: 2,
                                        entry_time: '29-May-2022 14:44:07'
                                      })
    expect(lot.park('scooter')).to eq({
                                        message: 'No space available'
                                      })
    Timecop.freeze('29-May-2022 15:40:07')
    expect(lot.unpark('scooter', '002')).to eq({
                                                 receipt_number: 'R-001',
                                                 entry_time: '29-May-2022 14:44:07',
                                                 exit_time: '29-May-2022 15:40:07',
                                                 fees: 10
                                               })
    Timecop.freeze('29-May-2022 15:59:07')
    expect(lot.park('motorcycle')).to eq({
                                           ticket_number: '003',
                                           spot_number: 2,
                                           entry_time: '29-May-2022 15:59:07'
                                         })
    Timecop.freeze('29-May-2022 17:44:07')
    expect(lot.unpark('motorcycle', '001')).to eq({
                                                    receipt_number: 'R-002',
                                                    entry_time: '29-May-2022 14:04:07',
                                                    exit_time: '29-May-2022 17:44:07',
                                                    fees: 40
                                                  })
  end
end
