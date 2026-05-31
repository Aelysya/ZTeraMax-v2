module Battle
  class Move
    class GMaxChiStrike < MaxMove
      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.alive_battlers(user.bank).each do |target|
          target.effects.add(Effects::ChiStrike.new(@logic, target))
        end
      end
    end
    Move.register(:s_gmax_chi_strike, GMaxChiStrike)
  end
end
