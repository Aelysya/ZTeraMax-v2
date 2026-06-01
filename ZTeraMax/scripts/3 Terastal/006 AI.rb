module Battle
  module AI
    class Base
      module TerastalPlugin
        # Try to find the battle action for a dedicated pokemon, extended to evaluate Terastal.
        # @param pokemon [PFM::PokemonBattler]
        # @return [Actions::Base, Array<Actions::Base>]
        def battle_action_for(pokemon)
          return super(pokemon) unless @can_terastal
          return super(pokemon) unless @scene.logic.terastal.can_ai_pokemon_terastal?(pokemon)

          # Apply tera type override from the marker before scoring, so move
          # heuristics can see the correct tera type.
          @scene.logic.terastal.apply_terastal_marker(pokemon)

          result = super(pokemon)

          # If the AI would rather switch, skip Terastal.
          return result if result.is_a?(Actions::Switch)

          return [Actions::Terastal.new(@scene, pokemon), result]
        end
      end
      prepend TerastalPlugin
    end

    # Module that enables Terastal usage for an AI level.
    module TerastalCapability
      private

      def init_capability
        super
        @can_terastal = true
      end
    end

    TrainerLv4.prepend(TerastalCapability)
    TrainerLv5.prepend(TerastalCapability)
    TrainerLv6.prepend(TerastalCapability)
    TrainerLv7.prepend(TerastalCapability)
  end
end
