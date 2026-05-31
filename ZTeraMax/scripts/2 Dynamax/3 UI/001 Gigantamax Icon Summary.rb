module UI
  class Summary_Top < SpriteStack
    module ZTeraMaxPlugin
      # List of species that have a Gigantamax form
      # @return [Array<Symbol>]
      GIGANTAMAX_SPECIES = %i[
        venusaur charizard blastoise butterfree pikachu meowth machamp
        gengar kingler lapras eevee snorlax garbodor melmetal rillaboom
        cinderace inteleon corviknight orbeetle drednaw coalossal flapple
        appletun sandaconda toxtricity centiskorch hatterene grimmsnarl
        alcremie copperaja duraludon urshifu eternatus
      ]

      # Set the Pokemon shown
      # @param pokemon [PFM::Pokemon]
      def data=(pokemon)
        super
        @gigantamax.visible = pokemon.gigantamax_factor && GIGANTAMAX_SPECIES.include?(pokemon.db_symbol)
      end

      def init_sprite
        super
        @gigantamax = create_gigantamax
      end

      # @return [Sprite]
      def create_gigantamax
        push(23, 25, 'gigantamax_icon')
      end
    end
    prepend ZTeraMaxPlugin
  end
end
