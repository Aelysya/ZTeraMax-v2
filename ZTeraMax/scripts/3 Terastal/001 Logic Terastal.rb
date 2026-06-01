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

      # Checks whether a non-player Pokémon can Terastallize based on a config marker,
      # without requiring the Tera Orb in their bag.
      # @param pokemon [PFM::PokemonBattler]
      # @return [Boolean]
      def can_ai_pokemon_terastal?(pokemon)
        return false unless TERASTAL_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.can_mega_evolve? || pokemon.mega_evolved? || pokemon.holds_z_crystal?
        return false if @used_terastal_tool_bags.include?(pokemon.bag)

        return !marker_for_terastal(pokemon).nil?
      end

      # Applies the Terastal marker tera type override (if present) to a non-player Pokémon.
      # @param pokemon [PFM::PokemonBattler]
      # @return [void]
      def apply_terastal_marker(pokemon)
        return if pokemon.from_party?

        marker = marker_for_terastal(pokemon)
        return unless marker

        tera_type_sym = marker[:teraType].to_s.to_sym
        pokemon.change_tera_type(tera_type_sym) if tera_type_sym
      end

      private

      # Finds the Terastal marker in the config that matches the given Pokémon.
      # @param pokemon [PFM::PokemonBattler]
      # @return [Hash, nil]
      def marker_for_terastal(pokemon)
        markers = Configs.z_tera_max.terastal_markers
        return nil unless markers

        trainer_db_id = @scene.battle_info.trainer_db_ids&.dig(pokemon.bank, pokemon.party_id)
        return markers.find { |m| m[:trainerId] == trainer_db_id && m[:pokemonSymbol].to_s.delete(':').to_sym == pokemon.db_symbol }
      end

      # Function that checks if any action of the player is a Terastal
      # @return [Boolean] true if any player action is an Terastal command, false otherwise.
      def any_terastal_player_action?
        @scene.player_actions.flatten.any? { |action| action.is_a?(Actions::Terastal) }
      end
    end

    class EndTurnHandler
      module ZTeraMaxPlugin
        def process_events
          super
          process_untera_end_turn_event
          @logic.delete_dead_effects
        end

        private

        def process_untera_end_turn_event
          @logic.all_battlers do |battler|
            next unless battler.dead? && battler.terastallized

            battler.terastallized = false
          end
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
