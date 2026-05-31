module Battle
  module Effects
    class Item
      class ChoiceItemMultiplier < Item
        module ZTeraMaxPlugin
          # Checks if the user can use the move
          # @param user [PFM::PokemonBattler]
          # @param move [Battle::Move]
          # @return [Boolean]
          # @note The move selection restriction stops working when user is dynamaxed
          def can_be_used?(user, move)
            return true if @target.effects.has?(:dynamaxed) # Has to be the effect to allow move selection when activating Dynamax button

            super
          end
        end
        prepend ZTeraMaxPlugin
      end

      class ChoiceBand < ChoiceItemMultiplier
        module ZTeraMaxPlugin
          # Give the atk modifier over given to the Pokemon with this effect
          # @return [Float, Integer] multiplier
          # @note The stat boost stops working when user is dynamaxed
          def atk_modifier
            return 1 if @target.dynamaxed

            super
          end
        end
        prepend ZTeraMaxPlugin
      end

      class ChoiceSpecs < ChoiceItemMultiplier
        module ZTeraMaxPlugin
          # Give the atk modifier over given to the Pokemon with this effect
          # @return [Float, Integer] multiplier
          # @note The stat boost stops working when user is dynamaxed
          def ats_modifier
            return 1 if @target.dynamaxed

            super
          end
        end
        prepend ZTeraMaxPlugin
      end

      class ChoiceScarf < ChoiceItemMultiplier
        module ZTeraMaxPlugin
          # Give the speed modifier over given to the Pokemon with this effect
          # @return [Float, Integer] multiplier
          # @note The stat boost stops working when user is dynamaxed
          def spd_modifier
            return 1 if @target.dynamaxed

            super
          end
        end
        prepend ZTeraMaxPlugin
      end
    end
  end
end
