module Battle
  module Effects
    class Taunt
      module ZTeraMaxPlugin
        # Function called when we try to check if the user cannot use a move
        # @param user [PFM::PokemonBattler]
        # @param move [Battle::Move]
        # @return [Proc, nil]
        def on_move_disabled_check(user, move)
          return if user.effects.has?(:z_power) && move.is_z

          return super
        end

        # Function called when we try to use a move as the user (returns :prevent if user fails)
        # @param user [PFM::PokemonBattler]
        # @param targets [Array<PFM::PokemonBattler>]
        # @param move [Battle::Move]
        # @return [:prevent, nil] :prevent if the move cannot continue
        def on_move_prevention_user(user, targets, move)
          return if user.effects.has?(:z_power) && move.is_z

          return super
        end
      end

      prepend ZTeraMaxPlugin
    end
  end
end
