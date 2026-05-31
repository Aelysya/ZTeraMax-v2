module Battle
  class Move
    class GMaxSweetness < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return actual_targets.all? { |target| target.status == 0 }
      end

      # Function that deals the heal to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, targets)
        target_cure = false
        @logic.allies_of(user).each do |target|
          next if target.status == 0

          scene.logic.status_change_handler.status_change(:cure, target)
          target_cure = true
        end
        scene.display_message_and_wait(parse_text(18, 70)) unless target_cure
      end
    end
    Move.register(:s_gmax_sweetness, GMaxSweetness)
  end
end
