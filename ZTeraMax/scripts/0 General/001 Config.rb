module Configs
  KEY_TRANSLATIONS[:useBuiltinMoveNameSlice] = :use_slice_name
  KEY_TRANSLATIONS[:gigantamaxChance] = :gigantamax_chance
  KEY_TRANSLATIONS[:dynamaxEnabledSwitch] = :dynamax_enabled_switch
  KEY_TRANSLATIONS[:exoticTeraTypeChance] = :exotic_tera_type_chance
  KEY_TRANSLATIONS[:terastalEnabledSwitch] = :terastal_enabled_switch
  KEY_TRANSLATIONS[:teraOrbChargeEnabledSwitch] = :tera_orb_charge_enabled_switch

  module Project
    class ZTeraMax
      # Ff the move name should be sliced using the plugin's method
      # @return [Boolean]
      attr_accessor :use_slice_name

      # The chance to generate a Pokémon with the Gigantamax factor
      # @return [Integer] Between 0 and 100
      attr_accessor :gigantamax_chance

      # Is the Dynamax enabled in battle?
      # @return [Boolean]
      attr_accessor :dynamax_enabled_switch

      # The chance to generate a Pokémon with a Tera type different from its original types
      # @return [Integer] Between 0 and 100
      attr_accessor :exotic_tera_type_chance

      # Is the Terastal enabled in battle?
      # @return [Boolean]
      attr_accessor :terastal_enabled_switch

      # Does the Tera Orb needs to be recharged after being used?
      # @return [Boolean]
      attr_accessor :tera_orb_charge_enabled_switch
    end
  end

  # @!method self.z_tera_max
  # @return [Project::ZTeraMax]
  register(:z_tera_max, 'z_tera_max_config', :json, false, Project::ZTeraMax)
end

module PSDKEditor
  def convert_z_tera_max_settings
    return if File.exist?(File.join(ROOT_CONFIGS, 'z_tera_max_config.json'))

    data_z_tera_max = { klass: 'Configs::Project::ZTeraMax' }
    data_z_tera_max[:useBuiltinMoveNameSlice] = PSDK_CONFIG.use_slice_name
    data_z_tera_max[:gigantamaxChance] = PSDK_CONFIG.gigantamax_chance
    data_z_tera_max[:dynamaxEnabledSwitch] = PSDK_CONFIG.dynamax_enabled_switch
    data_z_tera_max[:exoticTeraTypeChance] = PSDK_CONFIG.exotic_tera_type_chance
    data_z_tera_max[:terastalEnabledSwitch] = PSDK_CONFIG.terastal_enabled_switch
    data_z_tera_max[:teraOrbChargeEnabledSwitch] = PSDK_CONFIG.tera_orb_charge_enabled_switch
    File.write(File.join(ROOT_CONFIGS, 'z_tera_max_config.json'), JSON.pretty_generate(data_z_tera_max))
  end
end
