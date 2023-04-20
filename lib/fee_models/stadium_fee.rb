# frozen_string_literal: true
module FeeModels
  class StadiumFee < BaseFee
    def initialize(range_to_rate_map, hourly_rate_threshold, hourly_rate)
      @ranges_to_rate_map = range_to_rate_map
      @hourly_rate_threshold = hourly_rate_threshold
      @hourly_rate = hourly_rate
    end

    def calculate(duration_seconds)
      sum = @ranges_to_rate_map.reduce(0) do |acc, (range, rate)|
        next acc if duration_seconds < range.begin

        acc + rate
      end

      return sum if duration_seconds < @hourly_rate_threshold

      duration_hours = ((duration_seconds - @hourly_rate_threshold) / 3600.0).ceil
      sum + (@hourly_rate * duration_hours)
    end
  end
end
