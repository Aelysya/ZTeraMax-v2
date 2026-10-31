module BattleUI
  class PokemonSprite < ShaderedSprite
    module ZTeraMaxPlugin
      DYNAMAX_COLOR = [0.84, 0.07, 0.33, 0.5]
      CALYREX_COLOR = [0.07, 0.33, 0.84, 0.5]


      # Pokemon sprite zoom
      # @return [Integer]
      def sprite_zoom
        return 2 if @pokemon&.dynamaxed

        super
      end

      # Update the sprite
      def update
        super
        return unless @pokemon&.dynamaxed
        return shader.set_float_uniform('color', DYNAMAX_COLOR) unless @pokemon&.db_symbol == :calyrex

        shader.set_float_uniform('color', CALYREX_COLOR)
      end

      # Creates the deflating animation after dynamax expires
      def deflate_animation
        ya = Yuki::Animation

        size_animation = Yuki::Animation::ScalarAnimation.new(1, self, :zoom=, 2, 1)

        color_updater = proc do |alpha|
          next shader.set_float_uniform('color', DYNAMAX_COLOR[0..2] + [alpha]) unless @pokemon&.db_symbol == :calyrex

          next shader.set_float_uniform('color', CALYREX_COLOR[0..2] + [alpha])
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
