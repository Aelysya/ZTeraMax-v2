module Battle
  class Move
    class MeFirst
      module ZTeraMaxPlugin
        # Function that tests if the user is able to use the move
        # @param user [PFM::PokemonBattler] user of the move
        # @param targets [Array<PFM::PokemonBattler>] expected targets
        # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
        # @return [Boolean] if the procedure can continue
        def move_usable_by_user(user, targets)
          return false if targets.effects.has?(:z_power)

          return super
        end

        private

        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_z_effect(user, actual_targets)
          Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene) if @is_z

          skill = data_move(target_move(actual_targets.first))
          move = Battle::Move[skill.be_method].new(skill.db_symbol, 1, 1, @scene)
          move = logic.z_move.corresponding_z_move(move) unless move.status?
          def move.calc_mod2(user, target)
            super * 1.5
          end

          def move.chance_of_hit(user, target)
            return 100
          end
          use_another_move(move, user)
        end
      end

      prepend ZTeraMaxPlugin
    end
  end
end
