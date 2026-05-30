module Battle
  class Move
    # Move class for Splintered Stormshards Z-Move
    class SplinteredStormshards < ZMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return @logic.field_terrain_effect
      end

      # Function that deals the effect
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.fterrain_change_handler.fterrain_change_with_process(:none)
      end
    end
    Move.register(:s_splintered_stormshards, SplinteredStormshards)
  end
end
