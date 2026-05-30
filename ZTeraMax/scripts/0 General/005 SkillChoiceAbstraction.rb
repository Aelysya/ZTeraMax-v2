module BattleUI
  module SkillChoiceAbstraction
    module ZTeraMaxPlugin
      # Tell if the use of Z-Moves is enabled
      # @return [Boolean]
      attr_accessor :z_move_enabled

      # Tell if the use of Dynamax is enabled
      # @return [Boolean]
      attr_accessor :dynamax_enabled

      # Tell if the use of Terastal is enabled
      # @return [Boolean]
      attr_accessor :terastal_enabled

      # Reset the Skill choice
      # @param pokemon [PFM::PokemonBattler]
      def reset(pokemon)
        @z_move_enabled = false
        @dynamax_enabled = false
        @terastal_enabled = false
        super
      end
    end
    prepend ZTeraMaxPlugin
  end
end
