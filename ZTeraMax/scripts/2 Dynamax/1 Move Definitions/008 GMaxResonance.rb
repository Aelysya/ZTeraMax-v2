module Battle
  class Move
    class GMaxResonance < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return !@logic.bank_effects[user.bank]&.get(:aurora_veil)
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        turn_count = user.hold_item?(:light_clay) ? 8 : 5
        @logic.bank_effects[user.bank].add(Effects::AuroraVeil.new(@logic, user.bank, 0, turn_count))
      end
    end
    Move.register(:s_gmax_resonance, GMaxResonance)
  end
end
