# frozen_string_literal: true
module FeeModels
  class FlatFee < BaseFee
    def initialize(rate)
      @rate = rate
    end

    def calculate(duration_seconds)
      duration_hours = (duration_seconds / 3600.0).ceil
      @rate * duration_hours
    end
  end
end
