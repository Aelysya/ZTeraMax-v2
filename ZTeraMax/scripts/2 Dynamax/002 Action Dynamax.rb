module Battle
  module Actions
    # Class describing the Dynamax action
    class Dynamax < Base
      # Get the user of this action
      # @return [PFM::PokemonBattler]
      attr_reader :user

      # Create a new Dynamax action
      # @param scene [Battle::Scene]
      # @param user [PFM::PokemonBattler]
      def initialize(scene, user)
        super(scene)
        @user = user
      end

      # Compare this action with another
      # @param other [Base] other action
      # @return [Integer]
      def <=>(other)
        return 1 if other.is_a?(HighPriorityItem)
        return 1 if other.is_a?(Attack) && Attack.from(other).pursuit_enabled
        return 1 if other.is_a?(Item)
        return 1 if other.is_a?(Switch)
        return Dynamax.from(other).user.spd <=> @user.spd if other.is_a?(Dynamax)

        return -1
      end

      # Execute the action
      def execute
        @scene.logic.dynamax.mark_as_dynamax_used(@user)
        visual = @scene.visual
        sprite = visual.battler_sprite(@user.bank, @user.position)
        sprite.go_out
        visual.hide_info_bar(@user)
        wait_for(sprite, visual)
        @user.dynamax
        sprite.pokemon = @user if @user.gigantamax_factor
        sprite.visible = false
        sprite.go_in
        visual.show_info_bar(@user)
        wait_for(sprite, visual)
      end

      private

      # Wait for the sprite animation to be done
      # @param sprite [#done?]
      # @param visual [Battle::Visual]
      def wait_for(sprite, visual)
        until sprite.done?
          visual.update
          Graphics.update
        end
      end
    end
  end
end
