module Battle
  class Move
    class MirrorMove
      module ZTeraMaxPlugin
        # Function that tests if the user is able to use the move
        # @param user [PFM::PokemonBattler] user of the move
        # @param targets [Array<PFM::PokemonBattler>] expected targets
        # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
        # @return [Boolean] if the procedure can continue
        def move_usable_by_user(user, targets)
          return super unless user.effects.has?(:z_power)
          return false if targets.effects.has?(:z_power)

          return true
        end

        private

        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_z_effect(user, actual_targets)
          Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene) if @is_z

          move = last_move(user, actual_targets).dup
          move = logic.z_move.corresponding_z_move(move) unless move.status?

          def move.move_usable_by_user(user, targets)
            return true
          end
          use_another_move(move, user)
        end
      end

      prepend ZTeraMaxPlugin
    end
  end
end
