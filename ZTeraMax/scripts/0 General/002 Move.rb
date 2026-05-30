module Battle
  class Move
    module ZTeraMaxPlugin
      # If the move is a Z-Move
      # @return [Boolean]
      attr_accessor :is_z

      # Get the move name sliced to fit in the move button
      # @return [String]
      def sliced_name
        return name if name.size < 15

        return name.slice(0..12) << '...'
      end

      # Checks if the move overwhelms protected targets and does some damage through protect-like effects
      # @return [Boolean] If the move is overwhelming
      def overwhelms_protect?
        return false
      end

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      def initialize(db_symbol, pp, ppmax, scene)
        super
        @is_z = false
      end

      # Return the name of the skill
      # @note Adds a 'Z' affix if the move is a status Z-Move
      def name
        return parse_text(20_000, 6, PFM::Text::MOVE[0] => data.name) if @is_z && status?

        super
      end

      # Show the move usage message
      # @param user [PFM::PokemonBattler] user of the move
      def usage_message(user)
        pre_z_move_message(user) if user.effects.has?(:z_power) && @is_z

        super
      end

      # Display messages before using a Z-Move
      # @return [String]
      def pre_z_move_message(user)
        @scene.display_message_and_wait(parse_text_with_pokemon(20_000, 0, user))
        @scene.display_message_and_wait(parse_text_with_pokemon(20_000, 3, user))
      end
    end
    prepend ZTeraMaxPlugin
  end
end
