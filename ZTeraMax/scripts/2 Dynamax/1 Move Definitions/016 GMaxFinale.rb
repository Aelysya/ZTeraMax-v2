module Battle
  class Move
    class GMaxFinale < MaxMove
      private

      # Function that deals the heal to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, targets)
        alive_battlers(user.bank).each do |target|
          hp = target.max_hp / 6
          @logic.damage_handler.heal(target, hp)
        end
      end

      # Tell that the move is a heal move
      def heal?
        return true
      end
    end
    Move.register(:s_gmax_finale, GMaxFinale)
  end
end
