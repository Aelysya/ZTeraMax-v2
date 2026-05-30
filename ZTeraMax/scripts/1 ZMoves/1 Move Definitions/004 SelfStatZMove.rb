module Battle
  class Move
    class SelfStatZMove < ZMove
      # Function that deals the stat to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_stats(user, actual_targets)
        super(user, [user])
      end
    end
    Move.register(:s_self_stat_z_move, SelfStatZMove)
  end
end
