module Battle
  class Move
    class DamageOverFourTurnsMaxMove < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return false if @logic.foes_of(user).all? { |target| @logic.position_effects[target.bank][target.position].has?(:damage_over_four_turns) }

        return true
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next if @logic.position_effects[target.bank][target.position].has?(:damage_over_four_turns)

          @logic.add_position_effect(Battle::Effects::DamageOverFourTurns.new(@logic, target.bank, target.position, self))
        end
      end
    end
    Move.register(:s_damage_over_four_turns_max_move, DamageOverFourTurnsMaxMove)
  end
end
