module BattleUI
  class PokemonSprite < ShaderedSprite
    module ZTeraMaxPlugin
      # Pokemon sprite zoom
      # @return [Integer]
      def sprite_zoom
        return 2 if @pokemon.dynamaxed

        super
      end

      # Update the sprite
      def update
        super
        shader.set_float_uniform('color', [0.84, 0.07, 0.33, 0.5]) if @pokemon.dynamaxed
      end

      # Creates the deflating animation after dynamax expires
      def deflate_animation
        ya = Yuki::Animation

        size_animation = Yuki::Animation::ScalarAnimation.new(1, self, :zoom=, 2, 1)

        color_updater = proc do |alpha|
          shader.set_float_uniform('color', [0.84, 0.07, 0.33] + [alpha])
        end

        color_animation = Yuki::Animation::ScalarAnimation.new(1, color_updater, :call, 0.5, 0)

        animation = ya.player(
          ya.send_command_to(self, :zoom=, 1),
          ya.parallel(size_animation, color_animation)
        )
        animation.start
        animation_handler[:deflate] = animation
      end
    end
    prepend ZTeraMaxPlugin
  end
end
