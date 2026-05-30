module Battle
  class Move
    class Metronome
      module ZTeraMaxPlugin
        private

        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_z_effect(user, actual_targets)
          Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene) if @is_z

          skill = each_data_move.reject { |i| CANNOT_BE_SELECTED_MOVES.include?(i.db_symbol) }.sample(random: @logic.generic_rng)
          move = Battle::Move[skill.be_method].new(skill.id, 1, 1, @scene)
          move = logic.z_move.corresponding_z_move(move) unless move.status?
          def move.usage_message(user)
            @scene.visual.hide_team_info
            scene.display_message_and_wait(parse_text(18, 126, '[VAR MOVE(0000)]' => name))
            PFM::Text.reset_variables
          end
          use_another_move(move, user)
        end
      end

      prepend ZTeraMaxPlugin
    end
  end
end
