module Battle
  module AI
    class Base
      module DynamaxPlugin
        # Try to find the battle action for a dedicated pokemon, extended to evaluate Dynamax.
        # @param pokemon [PFM::PokemonBattler]
        # @return [Actions::Base, Array<Actions::Base>]
        def battle_action_for(pokemon)
          return super(pokemon) unless @can_dynamax
          return super(pokemon) unless @scene.logic.dynamax.can_ai_pokemon_dynamax?(pokemon)

          # Apply marker values (dynamax_level, gigantamax_factor) before moveset transformation
          # so G-Max move selection is correct.
          @scene.logic.dynamax.apply_marker(pokemon)
          @scene.logic.dynamax.update_moveset(pokemon, true)

          result = super(pokemon)

          # If the AI would rather switch, revert the moveset and skip Dynamax.
          if result.is_a?(Actions::Switch)
            pokemon.reset_to_original_moveset
            return result
          end

          return [Actions::Dynamax.new(@scene, pokemon), result]
        end
      end
      prepend DynamaxPlugin
    end

    # Module that enables Z-Move usage for an AI level.
    module DynamaxCapability
      private

      def init_capability
        super
        @can_dynamax = true
      end
    end

    TrainerLv4.prepend(DynamaxCapability)
    TrainerLv5.prepend(DynamaxCapability)
    TrainerLv6.prepend(DynamaxCapability)
    TrainerLv7.prepend(DynamaxCapability)
  end
end
