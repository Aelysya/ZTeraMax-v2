module Battle
  class Move
    class GMaxCuddle < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return actual_targets.any? { |target| !target.effects.has?(:attract) && user.gender * target.gender == 2 }
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next unless user.gender * target.gender == 2
          next if target.effects.has?(:attract)

          target.effects.add(Effects::Attract.new(@logic, target, user))
          scene.visual.show_status_animation(target, :attract)
          scene.display_message_and_wait(parse_text_with_pokemon(19, 327, target))

          handle_destiny_knot_effect(user, target) if target.hold_item?(:destiny_knot)
        end
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler]
      def handle_destiny_knot_effect(user, target)
        return if user.effects.has?(:attract)

        user.effects.add(Effects::Attract.new(@logic, user, target))
        scene.show_status_animation(target, :attract)
        scene.display_message_and_wait(parse_text_with_pokemon(19, 327, user))
      end
    end
    Move.register(:s_gmax_cuddle, GMaxCuddle)
  end
end
