module Battle
  module Actions
    # Class describing the Z-Move action
    class ZMove < Attack
      # Execute the action
      def execute
        super
        @scene.logic.z_move.mark_as_z_move_used(@launcher) if @move.is_z
      end
    end
  end
end
