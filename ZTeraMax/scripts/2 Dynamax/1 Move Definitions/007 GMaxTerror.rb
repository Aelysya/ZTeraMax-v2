module Battle
  class Move
    class GMaxTerror < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return actual_targets.any? { |target| !target.effects.has?(:cantswitch) }
      end

      # Function that deals the status changes to all foes
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next if target.effects.has?(:cantswitch)

          target.effects.add(Effects::CantSwitch.new(@logic, target, user, self))
          scene.display_message_and_wait(parse_text_with_pokemon(19, 875, target))
        end
      end
    end
    Move.register(:s_gmax_terror, GMaxTerror)
  end
end
