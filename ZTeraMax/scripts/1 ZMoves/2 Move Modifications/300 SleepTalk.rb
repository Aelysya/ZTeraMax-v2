module Battle
  class Move
    class SleepTalk
      module ZTeraMaxPlugin
        private

        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_z_effect(user, actual_targets)
          Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene) if @is_z

          move = usable_moves(user).sample(random: @logic.generic_rng).dup
          move = logic.z_move.corresponding_z_move(move) unless move.status?
          def move.move_usable_by_user(user, targets)
            return true
          end
          use_another_move(move, user)
        end

        # Function that list all the moves the user can pick
        # @param user [PFM::PokemonBattler]
        # @return [Array<Battle::Move>]
        def usable_moves(user)
          return user.original_moveset.reject { |skill| CANNOT_BE_SELECTED_MOVES.include?(skill.db_symbol) } if user.effects.has?(:z_power)

          return super
        end
      end

      prepend ZTeraMaxPlugin
    end
  end
end
