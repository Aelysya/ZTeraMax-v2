module Battle
  class Move
    # Move class for Guardian of Alola Z-Move
    class GuardianOfAlola < ZMove
      # Deals 3/4 of the target's current HP as fixed damage
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [Array<PFM::PokemonBattler>] target that will be affected by the move
      def damages(user, target)
        @critical = false
        @effectiveness = 1
        damage = (target.hp / 4 * 3).clamp(1, Float::INFINITY).floor
        log_data("Forced HP Move: #{damage} HP")
        return damage
      end
    end
    Move.register(:s_guardian_of_alola, GuardianOfAlola)
  end
end
