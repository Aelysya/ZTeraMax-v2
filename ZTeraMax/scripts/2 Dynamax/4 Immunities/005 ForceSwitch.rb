module Battle
  class Move
    class ForceSwitch < BasicWithSuccessfulEffect
      module ZTeraMaxPlugin
        private

        # Test if the effect is working
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        # @return [Boolean]
        def effect_working?(user, actual_targets)
          return actual_targets.any? { |target| !target.dynamaxed }
        end

        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_effect(user, actual_targets)
          super(user, actual_targets.reject(&:dynamaxed))
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
