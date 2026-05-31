module Battle
  class Move
    class GMaxMeltdown < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return actual_targets.any? { |target| !target.effects.has?(:torment) && !target.dynamaxed }
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next if target.effects.has?(:torment) || target.dynamaxed

          target.effects.add(Effects::Torment.new(@logic, target))
          @scene.display_message_and_wait(parse_text_with_pokemon(19, 577, target))
        end
      end
    end
    Move.register(:s_gmax_meltdown, GMaxMeltdown)
  end
end
