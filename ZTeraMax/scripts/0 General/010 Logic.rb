module Battle
  class Logic
    module ZTeraMaxPlugin
      # Get the ZMove helper
      # @return [ZMoves]
      attr_reader :z_move
      # Get the Dynamax helper
      # @return [Dynamax]
      attr_reader :dynamax
      # Get the Terastal helper
      # @return [Terastal]
      attr_reader :terastal

      # Create a new Logic instance
      # @param scene [Scene] scene that holds the logic object
      def initialize(scene)
        @z_move = ZMoves.new(scene)
        @dynamax = Dynamax.new(scene)
        @terastal = Terastal.new(scene)
        super
      end
    end
    prepend ZTeraMaxPlugin

    class MegaEvolve
      private

      # Function that checks if any action of the player is a mega evolve
      # @return [Boolean]
      # @note The method has been overriden to avoid checking for an Array Action, which would return true if any Action was a Dynamax Action
      def any_mega_player_action?
        @scene.player_actions.flatten.any? { |actions| actions.is_a?(Actions::Mega) }
      end
    end
  end
end
