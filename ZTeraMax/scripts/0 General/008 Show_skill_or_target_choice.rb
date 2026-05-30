module Battle
  class Visual
    module ZTeraMaxPlugin
      # Make the result of show_target_choice method
      # @param result [Array, :auto, :cancel]
      def stc_result(result = :auto)
        return handle_cancel_result(@skill_choice_ui.pokemon) if result == :cancel

        arr = super

        arr << @skill_choice_ui.z_move_enabled
        arr << @skill_choice_ui.dynamax_enabled
        arr << @skill_choice_ui.terastal_enabled

        return arr
      end
    end
    prepend ZTeraMaxPlugin
  end
end
