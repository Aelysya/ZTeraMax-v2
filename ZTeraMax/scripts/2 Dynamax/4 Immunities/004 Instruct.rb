module Battle
  class Move
    class Instruct < Move
      module ZTeraMaxPlugin
        private

        # @param user [PFM::PokemonBattler] user of the move
        # @param target [PFM::PokemonBattler] expected target
        # @return [Boolean] if the procedure can continue
        def move_usable?(user, target)
          return false if target.dynamaxed

          super
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
