module Battle
  class Logic
    # Logic for Terastal
    class Terastal
      # List of tools that allow Terastal
      TERASTAL_TOOLS = %i[tera_orb]

      # Create the Terastal logic
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        @used_terastal_tool_bags = []
      end

      # Determines if a given Pokémon can Terastal.
      # @param pokemon [Pokemon] The Pokémon to check.
      # @return [Boolean] True if the Pokémon can Terastallize, false otherwise.
      def can_pokemon_terastal?(pokemon)
        return false unless TERASTAL_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.from_party? && any_terastal_player_action?
        return false if pokemon.can_mega_evolve? || pokemon.mega_evolved? || pokemon.holds_z_crystal?

        return !@used_terastal_tool_bags.include?(pokemon.bag)
      end

      # Marks the given Pokémon's trainer as having Terastallized.
      # @param pokemon [Pokemon] The Pokémon that has Terastallized.
      # @return [void]
      def mark_as_terastal_used(pokemon)
        @used_terastal_tool_bags << pokemon.bag
      end

      private

      # Function that checks if any action of the player is a Terastal
      # @return [Boolean] true if any player action is an Terastal command, false otherwise.
      def any_terastal_player_action?
        @scene.player_actions.flatten.any? { |action| action.is_a?(Actions::Terastal) }
      end
    end

    # class BattleEndHandler < ChangeHandlerBase
    #   module TerastalPlugin
    #     # Handle form recalibration after battle
    #     # @param players_creatures [Array<PFM::PokemonBattler>]
    #     def handle_form_recalibration(players_creatures)
    #       players_creatures.each { |pokemon| pokemon.terastallized = false }
    #       super
    #     end
    #   end
    #   prepend TerastalPlugin
    # end

    # class EndTurnHandler
    #   module TerastalPlugin

    #     def process_events
    #       super
    #       process_untera_end_turn_event
    #       @logic.delete_dead_effects
    #     end

    #     private

    #     def process_untera_end_turn_event
    #       @logic.all_battlers do |battler|
    #         next unless battler.dead? && battler.terastallized

    #         battler.terastallized = false
    #       end
    #     end
    #   end
    #   prepend TerastalPlugin
    # end
  end
end
