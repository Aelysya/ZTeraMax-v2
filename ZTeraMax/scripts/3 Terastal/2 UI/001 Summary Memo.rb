module UI
  class Summary_Memo < SpriteStack
    module ZTeraMaxPlugin
      # Initialize the Memo part
      # @note "Tera Type" text is added, Tera type icon is added, primary types are placed differently, hence the need to re-write the entire method
      def init_memo
        texts = text_file_get(27)
        tera_texts = text_file_get(20_000)
        with_surface(114, 19, 95) do
          # --- Static part ---
          add_line(0, texts[2]) # Nom
          no_egg add_line(1, texts[0]) # NoPokedex
          @level_text = no_egg(add_line(1, texts[29], dx: 1)) # Level
          no_egg add_line(2, texts[3]) # Type
          no_egg add_line(3, texts[8]) # DO
          no_egg add_line(3, texts[9], dx: 1) # Numero id
          no_egg add_line(2, tera_texts[23], dx: 1)
          no_egg add_line(4, texts[10]) # Pt exp
          no_egg add_line(5, texts[12]) # Next lvl
          no_egg add_line(6, text_get(23, 7)) # Objet
          # --- Data part ---
          with_font(20) { no_egg add_text(11, 125, 56, nil, 'EXP') }
          add_line(0, :name, 2, type: SymText, color: 1, dx: 1)
          @id = no_egg add_line(1, :id_text, 2, type: SymText, color: 1)
          @level_value = no_egg(add_line(1, :level_text, 2, type: SymText, color: 1, dx: 1))
          no_egg add_line(3, :trainer_id_text, 2, type: SymText, color: 1, dx: 1)
          no_egg add_line(4, :exp_text, 2, type: SymText, color: 1, dx: 1)
          no_egg add_line(5, :exp_remaining_text, 2, type: SymText, color: 1, dx: 1)
          no_egg add_line(6, :item_name, 2, type: SymText, color: 1, dx: 1)
        end
        no_egg add_text(114, 19 + 16 * 3, 92, 16, :trainer_name, 2, type: SymText, color: 1)
        no_egg push(142, 19 + 34, nil, type: Type1Sprite)
        no_egg push(176, 19 + 34, nil, type: Type2Sprite)

        no_egg push(275, 19 + 34, nil, type: TeraTypeSprite)
      end
    end
    prepend ZTeraMaxPlugin
  end

  # Sprite that show the Tera type of the Pokemon
  class TeraTypeSprite < Type1Sprite
    private

    # Retrieve the data source of the type sprite
    # @return [Symbol]
    def data_source
      :tera_type
    end
  end
end
