# frozen_string_literal: true
module FeeModels
  # abstract class
  class BaseFee
    def calculate(duration)
      raise NotImplementedError
    end
  end
end
