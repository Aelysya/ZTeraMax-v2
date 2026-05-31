module Battle
  class Move
    class BindingMaxMove < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        return @logic.foes_of(user).any? { |target| !target.type_ghost? && !target.effects.has?(:bind) }
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        turn_count = user.hold_item?(:grip_claw) ? 7 : @logic.generic_rng.rand(4..5)
        @logic.foes_of(user).each do |target|
          next if target.type_ghost? || target.effects.has?(:bind)

          target.effects.add(Effects::Bind.new(@logic, target, user, turn_count, self))
        end
      end
    end
    Move.register(:s_binding_max_move, BindingMaxMove)
  end
end
