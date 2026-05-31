module Battle
  class Move
    class StatusMaxMove < MaxMove
      private

      # Function that deals the status changes to all foes
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_status(user, actual_targets)
        super(user, @logic.foes_of(user))
      end
    end
    Move.register(:s_status_max_move, StatMaxMove)
  end
end
