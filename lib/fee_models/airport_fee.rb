# frozen_string_literal: true
module FeeModels
  class AirportFee < BaseFee
    def initialize(range_to_rate_map, daily_rate)
      @ranges_to_rate_map = range_to_rate_map
      @daily_rate = daily_rate
    end

    def calculate(duration_seconds)
      if duration_seconds < 24.hours
        _range, rate = @ranges_to_rate_map.detect do |range, _rate|
          range.include?(duration_seconds)
        end
        rate
      else
        duration_days = ((duration_seconds) / (3600.0 * 24)).ceil
        @daily_rate * duration_days
      end
    end
  end
end
