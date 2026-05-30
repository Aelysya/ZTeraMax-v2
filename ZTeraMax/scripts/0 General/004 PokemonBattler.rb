module PFM
  class PokemonBattler < Pokemon
    module ZTeraMaxPlugin
      # @return [Array<Battle::Move>] the original moveset of the Pokemon
      attr_accessor :original_moveset
      # @return [Boolean] If the Pokémon is Dynamaxed
      attr_accessor :dynamaxed
      # @return [Integer, Boolean] Holds the original form of the Pokémon when it is Gigantamaxed, false when not Gigantamaxed
      attr_accessor :gigantamaxed

      # List of moves that should ignore abilities
      # @return [Array<Symbol>]
      MOVES_IGNORING_ABILITIES.concat(%i[searing_sunraze_smash menacing_moonraze_maelstrom light_that_burns_the_sky
                                         gmax_drum_solo gmax_fireball gmax_hydrosnipe])

      COPIED_PROPERTIES.concat(%i[@dynamax_level @gigantamax_factor])

      # Create a new PokemonBattler
      # @param original [PFM::Pokemon] original Pokemon (protected during the battle)
      # @param scene [Battle::Scene] current battle scene
      # @param max_level [Integer] new max level for Online battle
      def initialize(original, scene, max_level = Float::INFINITY)
        super
        @original_moveset = []
        @dynamaxed = false
        @gigantamaxed = false
      end
    end
    prepend ZTeraMaxPlugin
  end
end
