module Battle
  class Scene
    alias default_target_choice target_choice
    # Method that asks the target of the choosen move
    def target_choice
      launcher, skill, target_bank, target_position, mega, z_move, dynamax, terastal = @visual.show_target_choice
      effect = launcher&.effects&.get(&:force_next_move?)
      if launcher && skill
        action_class = effect ? effect.action_class : Actions::Attack
        next_action = action_class.new(self, skill, launcher, target_bank, target_position)
        if mega
          @player_actions << [next_action, Actions::Mega.new(self, launcher)]
        elsif z_move
          @player_actions << Actions::ZMove.new(self, skill, launcher, target_bank, target_position)
        elsif dynamax
          @player_actions << [next_action, Actions::Dynamax.new(self, launcher)]
        elsif terastal
          @player_actions << [next_action, Actions::Terastal.new(self, launcher)]
        else
          @player_actions << next_action
        end
        log_debug("Action : #{@player_actions.last}") if debug?
        @next_update = can_player_make_another_action_choice? ? :player_action_choice : :trigger_all_AI
      else
        @next_update = effect ? :player_action_choice : :skill_choice
      end
    ensure
      @skip_frame = true
    end
  end
end
