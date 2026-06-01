module BattleUI
  class InfoBar < UI::SpriteStack
    module ZTeraMaxPlugin
      def create_sprites
        super

        create_tera_type_icon
      end

      # Create the Tera Type icon
      def create_tera_type_icon
        add_sprite(120, enemy? ? 7 : -5, nil, type: BattleTeraTypeSprite)
      end

      class BattleTeraTypeSprite < SpriteSheet
        # Create a new Type Sprite
        # @param viewport [Viewport, nil] the viewport in which the sprite is stored
        def initialize(viewport)
          super(viewport, 1, each_data_type.size)
          load_texture
        end

        # Set the Pokemon used to show the type
        # @param pokemon [PFM::Pokemon, nil]
        def data=(pokemon)
          self.visible = pokemon.terastallized
          self.sy = pokemon.tera_type if visible
        end

        private

        # Load the graphic resource
        def load_texture
          set_bitmap('battle/tera_types', :interface)
        end

        # Retrieve the data source of the type sprite
        # @return [Symbol]
        def data_source
          :tera_type
        end
      end
    end
    prepend ZTeraMaxPlugin
  end
end
