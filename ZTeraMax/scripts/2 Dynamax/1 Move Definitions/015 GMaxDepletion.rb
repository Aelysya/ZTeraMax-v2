module Battle
  class Move
    class GMaxDepletion < MaxMove
      # Function that tests if the user is able to use the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
      # @return [Boolean] if the procedure can continue
      def move_usable_by_user(user, targets)
        return false unless super

        if targets.all? { |target| target.skills_set[find_last_skill_position(target)]&.pp == 0 || target.move_history.empty? }
          show_usage_failure(user)
          return false
        end

        return true
      end

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next if target.move_history.empty?

          last_skill = find_last_skill_position(target)
          next unless target.skills_set[last_skill].pp > 0

          num = 2.clamp(1, target.skills_set[last_skill].pp)
          target.skills_set[last_skill].pp -= num
          scene.display_message_and_wait(parse_text_with_pokemon(19, 641, target, PFM::Text::MOVE[1] => target.skills_set[last_skill].name, '[VAR NUM1(0002)]' => num.to_s))
        end
      end

      # Find the last skill used position in the moveset of the Pokemon
      # @param pokemon [PFM::PokemonBattler]
      # @return [Integer]
      def find_last_skill_position(pokemon)
        return 0 if pokemon.move_history.empty?

        pokemon.skills_set.each_with_index do |skill, i|
          return i if skill && skill.id == pokemon.move_history.last.move.id
        end
        return 0
      end
    end
    Move.register(:s_gmax_depletion, GMaxDepletion)
  end
end
