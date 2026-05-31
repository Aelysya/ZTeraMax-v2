module Battle
  class Move
    class GMaxReplenish < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return actual_targets.any? { |target| target.item_consumed && target.consumed_item != :__undef__ }
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        alive_battlers(user.bank).each do |target|
          next unless target.item_consumed
          next if target.consumed_item == :__undef__
          next unless bchance?(0.5, @logic)

          @scene.logic.item_change_handler.change_item(target.consumed_item, true, target, user, self)
        end
      end
    end
    Move.register(:s_gmax_replenish, GMaxReplenish)
  end
end
