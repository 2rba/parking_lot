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

  context 'with wrong ticket number' do
    it 'raises exception' do
      expect { subject.unpark('motorcycle', '001') }.to raise_error 'unknown ticket number'
    end
  end
end
