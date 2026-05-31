module Battle
  class Move
    class Encore < Move
      module ZTeraMaxPlugin
        private

        # Tell if the target can be Encore'd
        # @param target [PFM::PokemonBattler]
        # @return [Boolean]
        def cant_encore_target?(target)
          return true if target.dynamaxed

          super
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
