module PFM
  class PokemonBattler < Pokemon
    module ZTeraMaxPlugin
      # @return [Array<Battle::Move>] the original moveset of the Pokemon
      attr_accessor :original_moveset
      # @return [Boolean] If the Pokémon is Dynamaxed
      attr_accessor :dynamaxed
      # @return [Integer, Boolean] Holds the original form of the Pokémon when it is Gigantamaxed, false when not Gigantamaxed
      attr_accessor :gigantamaxed
      # @return [Boolean] If the Pokémon is Terastallized
      attr_accessor :terastallized
      # @return [Array<Integer>] List of types that have been Stellar-boosted
      attr_accessor :stellar_boosted_types

      # List of moves that should ignore abilities
      # @return [Array<Symbol>]
      MOVES_IGNORING_ABILITIES.concat(%i[searing_sunraze_smash menacing_moonraze_maelstrom light_that_burns_the_sky
                                         gmax_drum_solo gmax_fireball gmax_hydrosnipe])

      COPIED_PROPERTIES.concat(%i[@dynamax_level @gigantamax_factor @tera_type])

      # Create a new PokemonBattler
      # @param original [PFM::Pokemon] original Pokemon (protected during the battle)
      # @param scene [Battle::Scene] current battle scene
      # @param max_level [Integer] new max level for Online battle
      def initialize(original, scene, max_level = Float::INFINITY)
        super
        @original_moveset = []
        @dynamaxed = false
        @gigantamaxed = false
        @terastallized = false
        @stellar_boosted_types = []
      end

      # Check if the Pokemon can Gigantamax
      # @return [Integer, false] form index if the Pokemon can Gigantamax, false otherwise
      def can_gigantamax?
        return false unless @gigantamax_factor

        return 40 unless %i[urshifu toxtricity].include?(db_symbol)

        return @form + 40
      end

      # Boost Pokemon's HP after Dynamax and change its form to Gigantamax if appliable
      def dynamax
        @hp = (@hp * (1.5 + 0.05 * @dynamax_level.to_i)).ceil
        @dynamaxed = true

        gigantamax_form = can_gigantamax?
        return unless gigantamax_form

        @gigantamaxed = @form # Keep original form in memory
        @form = gigantamax_form
      end

      # Reset the Pokemon to its normal form after Dynamax
      def undynamax
        return unless @dynamaxed

        reset_to_original_moveset
        @hp = (@hp / (1.5 + 0.05 * @dynamax_level.to_i)).floor.clamp(0, max_hp)
        @dynamaxed = false

        return unless @gigantamaxed

        @form = @gigantamaxed
        @gigantamaxed = false
      end

      # Return the max HP of the Pokemon
      # @return [Integer]
      def max_hp
        if effects.has?(:dynamaxed)
          return 1 if db_symbol == :shedinja

          bonus_hp = 0.5 + 0.05 * @dynamax_level.to_i
          hp = super

          return (hp + hp * bonus_hp).ceil
        end

        return super
      end
    end
    prepend ZTeraMaxPlugin
  end
end
