module Battle
  class Logic
    # Logic for Dynamax
    class Dynamax
      # List of tools that allow Dynamax
      # @return [Array<Symbol>]
      DYNAMAX_TOOLS = %i[dynamax_band]

      # List of Pokémon that cannot Dynamax
      # @return [Array<Symbol>]
      NO_DYNAMAX_POKEMON = %i[zacian zamazenta]

      # List of Max Moves by type
      # @return [Hash{Symbol => Symbol}]
      MAX_MOVES = {
        normal: :max_strike,
        fighting: :max_knuckle,
        flying: :max_airstream,
        poison: :max_ooze,
        ground: :max_quake,
        rock: :max_rockfall,
        bug: :max_flutterby,
        ghost: :max_phantasm,
        steel: :max_steelspike,
        fire: :max_flare,
        water: :max_geyser,
        grass: :max_overgrowth,
        electric: :max_lightning,
        psychic: :max_mindstorm,
        ice: :max_hailstorm,
        dragon: :max_wyrmwind,
        dark: :max_darkness,
        fairy: :max_starfall
      }

      # List of signature Max Moves by species and type
      # @return [Hash{Symbol => {type: Symbol, move: Symbol}}]
      SIGNATURE_MAX_MOVES = {
        venusaur: { type: :grass, move: :gmax_vine_lash },
        charizard: { type: :fire, move: :gmax_wildfire },
        blastoise: { type: :water, move: :gmax_cannonade },
        butterfree: { type: :bug, move: :gmax_befuddle },
        pikachu: { type: :electric, move: :gmax_volt_crash },
        meowth: { type: :normal, move: :gmax_gold_rush },
        machamp: { type: :fighting, move: :gmax_chi_strike },
        gengar: { type: :ghost, move: :gmax_terror },
        kingler: { type: :water, move: :gmax_foam_burst },
        lapras: { type: :ice, move: :gmax_resonance },
        eevee: { type: :normal, move: :gmax_cuddle },
        snorlax: { type: :normal, move: :gmax_replenish },
        garbodor: { type: :poison, move: :gmax_malodor },
        melmetal: { type: :steel, move: :gmax_meltdown },
        rillaboom: { type: :grass, move: :gmax_drum_solo },
        cinderace: { type: :fire, move: :gmax_fireball },
        inteleon: { type: :water, move: :gmax_hydrosnipe },
        corviknight: { type: :flying, move: :gmax_wind_rage },
        orbeetle: { type: :psychic, move: :gmax_gravitas },
        drednaw: { type: :water, move: :gmax_stonesurge },
        coalossal: { type: :rock, move: :gmax_volcalith },
        flapple: { type: :grass, move: :gmax_tartness },
        appletun: { type: :grass, move: :gmax_sweetness },
        sandaconda: { type: :ground, move: :gmax_sand_blast },
        toxtricity: { type: :electric, move: :gmax_stun_shock },
        centiskorch: { type: :fire, move: :gmax_centiferno },
        hatterene: { type: :fairy, move: :gmax_smite },
        grimmsnarl: { type: :dark, move: :gmax_snooze },
        alcremie: { type: :fairy, move: :gmax_finale },
        copperajah: { type: :steel, move: :gmax_steelsurge },
        duraludon: { type: :dragon, move: :gmax_depletion }
      }

      # Create the Dynamax logic
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        @used_dynamax_tool_bags = []
      end

      # Marks the given Pokémon's trainer as having used the Dynamax.
      # @param pokemon [Pokemon] The Pokémon that has used the Dynamax.
      # @return [void]
      def mark_as_dynamax_used(pokemon)
        @used_dynamax_tool_bags << pokemon.bag
      end

      # Determines if a given Pokémon can Dynamax.
      # @param pokemon [Pokemon] The Pokémon to check.
      # @return [Boolean] True if the Pokémon can Dynamax, false otherwise.
      def can_pokemon_dynamax?(pokemon)
        return false if NO_DYNAMAX_POKEMON.include?(pokemon.db_symbol)
        return false unless DYNAMAX_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.from_party? && any_dynamax_player_action?
        return false if pokemon.can_mega_evolve? || pokemon.mega_evolved? || pokemon.holds_z_crystal?

        return !@used_dynamax_tool_bags.include?(pokemon.bag)
      end

      # Updates the moveset of a given Pokémon
      # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
      # @param dynamax_activated [Boolean] Whether to set the moveset to the Dynamax state or the original state.
      def update_moveset(pokemon, dynamax_activated)
        return pokemon.reset_to_original_moveset unless dynamax_activated

        pokemon.effects.add(Effects::Dynamaxed.new(@scene.logic, pokemon))
        pokemon.moveset.each_with_index do |move, i|
          pokemon.original_moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene)

          if move.status?
            pokemon.moveset[i] = Battle::Move[:s_max_guard].new(:max_guard, @scene, move)
            pokemon.moveset[i].is_max = true
          else
            pokemon.moveset[i] = replace_with_max_move(pokemon, move)
          end
        end
      end

      # Get the Max Move corresponding to a certain move
      # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated
      # @param move [Move] The move to be replaced with a Max Move.
      # @return [Move] The corresponding Max Move.
      def replace_with_max_move(pokemon, move)
        return handle_urshifu_case(pokemon, move) if pokemon.db_symbol == :urshifu

        move_type = data_move(move.db_symbol).type
        if SIGNATURE_MAX_MOVES.key?(pokemon.db_symbol) && SIGNATURE_MAX_MOVES[pokemon.db_symbol][:type] == move_type && pokemon.gigantamax_factor
          max_move_symbol = SIGNATURE_MAX_MOVES[pokemon.db_symbol][:move]
        else
          max_move_symbol = MAX_MOVES[move_type]
        end

        return Battle::Move[data_move(max_move_symbol).be_method].new(max_move_symbol, @scene, move)
      end

      # Handle the Urshifu exception when finding the corresponding signature Max Move
      # @param pokemon [Pokemon] Urshifu
      # @param move [Move] The move to be replaced with a Max Move.
      # @return [Move] The corresponding Max Move.
      def handle_urshifu_case(pokemon, move)
        move_type = data_move(move.db_symbol).type

        return Battle::Move[:s_max_move].new(:gmax_one_blow, @scene, move) if pokemon.form == 0 && move_type == :dark
        return Battle::Move[:s_max_move].new(:gmax_rapid_flow, @scene, move) if pokemon.form == 1 && move_type == :water

        max_move_symbol = MAX_MOVES[move_type]
        return Battle::Move[data_move(max_move_symbol).be_method].new(max_move_symbol, @scene, move)
      end

      private

      # Function that checks if any action of the player is a Dynamax
      # @return [Boolean] true if any player action is a Dynamax command, false otherwise.
      def any_dynamax_player_action?
        @scene.player_actions.flatten.any? { |action| action.is_a?(Actions::Dynamax) }
      end
    end

    class BattleEndHandler < ChangeHandlerBase
      module ZTeraMaxPlugin
        # Handle form recalibration after battle
        # @param players_creatures [Array<PFM::PokemonBattler>]
        def handle_form_recalibration(players_creatures)
          players_creatures.each(&:undynamax)
          super
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
