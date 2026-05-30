module Battle
  class Move
    # Class for Light That Burns The Sky Z-Move
    class LightThatBurnsTheSky < ZMove
      def damages(user, target)
        if user.atk > user.ats
          @physical = true
          @special = false
        else
          @physical = false
          @special = true
        end

        super
      end

      # Is the skill physical ?
      # @return [Boolean]
      def physical?
        return @physical.nil? ? super : @physical
      end

      # Is the skill special ?
      # @return [Boolean]
      def special?
        return @special.nil? ? super : @special
      end
    end
    Move.register(:s_light_that_burns_the_sky, LightThatBurnsTheSky)
  end
end
