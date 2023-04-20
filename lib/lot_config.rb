# frozen_string_literal: true
class LotConfig
  def initialize(vehicle_types_to_capacy_map, vehicle_type_to_fee_model_map)
    raise 'Vehicle types should be equal' if vehicle_types_to_capacy_map.keys.flatten != vehicle_type_to_fee_model_map.keys.flatten

    @vehicle_type_to_capacy_manager_map = vehicle_types_to_capacy_map.flat_map do |vehicle_types, capacity|
      spot_manager = SpotManager.new(capacity)
      vehicle_types.map { |vehicle_type| [vehicle_type, spot_manager] }
    end.to_h
    @vehicle_type_to_fee_model_map = vehicle_type_to_fee_model_map.flat_map do |vehicle_types, fee_model|
      vehicle_types.map { |vehicle_type| [vehicle_type, fee_model] }
    end.to_h
  end

  def spot_manager(vehicle_type)
    @vehicle_type_to_capacy_manager_map.fetch(vehicle_type)
  end

  def fee_model(vehicle_type)
    @vehicle_type_to_fee_model_map.fetch(vehicle_type)
  end
end
