module Battle
  class Move
    class Torment < Move
      module ZTeraMaxPlugin
        # Test if the target is immune
        # @param user [PFM::PokemonBattler]
        # @param target [PFM::PokemonBattler]
        # @return [Boolean]
        def target_immune?(user, target)
          return true if target.dynamaxed

          super
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
