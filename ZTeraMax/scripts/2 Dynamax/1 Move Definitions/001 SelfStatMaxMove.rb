module Battle
  class Move
    class SelfStatMaxMove < MaxMove
      private

      # Function that deals the stat changes to the pokemon and its allies
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_stats(user, actual_targets)
        super(user, @logic.alive_battlers(user.bank))
      end
    end
    Move.register(:s_self_stat_max_move, SelfStatMaxMove)
  end
end
