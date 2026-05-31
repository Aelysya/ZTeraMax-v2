module Battle
  class Move
    class DoubleDamageOnDynamax < Basic
      # Get the real base power of the move (taking in account all parameter)
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def real_base_power(user, target)
        return target.dynamaxed ? power * 2 : power
      end
    end
    Move.register(:s_double_damage_on_dynamax, DoubleDamageOnDynamax)
  end
end
