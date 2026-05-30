module Battle
  class Move
    module ZTeraMaxPlugin
      module_function

      # Internal procedure of the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      def proceed_internal_z_move(user, targets)
        unless (actual_targets = proceed_internal_precheck(user, targets))
          return user.add_move_to_history(self, targets) && user.reset_to_original_moveset
        end

        post_accuracy_check_effects(user, actual_targets)

        post_accuracy_check_move(user, actual_targets)

        play_animation(user, targets)

        deal_damage(user, actual_targets) &&
          effect_working?(user, actual_targets) &&
          deal_status(user, actual_targets) &&
          deal_stats(user, actual_targets) &&
          deal_z_effect(user, actual_targets)

        user.add_move_to_history(self, actual_targets)
        user.add_successful_move_to_history(self, actual_targets)
        @scene.visual.set_info_state(:move_animation)
        @scene.visual.wait_for_animation

        user.reset_to_original_moveset
      end

      # Check if the move bypass chance of hit and cannot fail
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Boolean]
      def bypass_chance_of_hit?(user, target)
        return true if user.effects.has?(:z_power) && @is_z

        return super
      end

      # Function that deals the Z-effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_z_effect(user, actual_targets)
        Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene) if @is_z && Z_STATUS_MOVES_EFFECTS.key?(db_symbol)
        deal_effect(user, actual_targets)
        return true
      end
    end
    prepend ZTeraMaxPlugin
  end
end
