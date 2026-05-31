module Battle
  class Move
    # Class for Z-Moves
    class ZMove < Basic
      # Create a new Z-Move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      def initialize(db_symbol, pp, ppmax, scene)
        super
        @is_z = true
      end

      # Checks if the move overwhelms protected targets and does some damage through protect-like effects
      # @return [Boolean] If the move is overwhelming
      def overwhelms_protect?
        return true
      end
    end
  end
end
