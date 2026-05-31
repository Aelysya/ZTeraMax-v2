module Battle
  module Effects
    class Ability
      class SheerForce < Ability
        module ZTeraMaxPlugin
          # Return the specific proceed_internal if the condition is fulfilled
          # @param user [PFM::PokemonBattler]
          # @param targets [Array<PFM::PokemonBattler>]
          # @param move [Battle::Move]
          # @note SheerForce effect stops working when user is dynamaxed
          def specific_proceed_internal(user, targets, move)
            return if @target.dynamaxed

            super
          end

          # Give the move base power mutiplier
          # @param user [PFM::PokemonBattler] user of the move
          # @param target [PFM::PokemonBattler] target of the move
          # @param move [Battle::Move] move
          # @return [Float, Integer] multiplier
          # @note The stat boost stops working when user is dynamaxed
          def base_power_multiplier(user, target, move)
            return 1 if @target.dynamaxed

            super
          end
        end
        prepend ZTeraMaxPlugin
      end
    end
  end
end
