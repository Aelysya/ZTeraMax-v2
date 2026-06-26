module Battle
  class Move
    class ChangeType < Move
      module ZTeraMaxPlugin
        # Method that tells if the Move's effect can proceed
        # @param target [PFM::PokemonBattler]
        # @return [Boolean]
        def condition(target)
          return false if target.terastallized

          super
        end
      end
      prepend ZTeraMaxPlugin
    end

    class AddThirdType < Move
      module ZTeraMaxPlugin
        # Test if the target is immune
        # @param user [PFM::PokemonBattler]
        # @param target [PFM::PokemonBattler]
        # @return [Boolean]
        def target_immune?(user, target)
          return true if target.terastallized

          super
        end
      end
      prepend ZTeraMaxPlugin
    end

    class BurnUp < BasicWithSuccessfulEffect
      module ZTeraMaxPlugin
        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_effect(user, actual_targets)
          return if user.terastallized

          super
        end
      end
      prepend ZTeraMaxPlugin
    end
  end

  module Effects
    class Ability
      class Libero < Ability
        module ZTeraMaxPlugin
          # Function called before the accuracy check of a move is done
          # @param logic [Battle::Logic] logic of the battle
          # @param scene [Battle::Scene] battle scene
          # @param targets [PFM::PokemonBattler]
          # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
          # @param skill [Battle::Move, nil] Potential move used
          def on_pre_accuracy_check(logic, scene, targets, launcher, skill)
            return if @target.terastallized

            super
          end
        end
        prepend ZTeraMaxPlugin
      end
    end
  end
end
