module Battle
  module Effects
    class MaxGuard < Protect
      # Function called when we try to check if the target evades the move
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler] expected target
      # @param move [Battle::Move]
      # @return [Boolean] if the target is evading the move
      def on_move_prevention_target(user, target, move)
        return super unless move.overwhelms_protect?

        # Override the protect effect allowing overwhelming moves to go through
        return false if user.has_ability?(:unseen_fist) && move.direct?
        return false if %i[gmax_one_blow gmax_rapid_flow].include?(move.db_symbol)

        play_protect_effect(user, target, move)
        return true
      end
    end
    Protect.register(:max_guard, MaxGuard)
  end
end
