module Battle
  module Effects
    class DamageOverFourTurns < PositionTiedEffectBase
      # Create a new position tied effect
      # @param logic [Battle::Logic] logic used to get all the handler in order to allow the effect to work
      # @param bank [Integer] bank where the effect is tied
      # @param position [Integer] position where the effect is tied
      # @param move [Battle::Move] move responsive of the effect
      def initialize(logic, bank, position, move, counter = 4)
        super(logic, bank, position)
        @move = move
        @counter = counter
      end

      # Function called at the end of a turn
      # @param logic [Battle::Logic] logic of the battle
      # @param scene [Battle::Scene] battle scene
      # @param battlers [Array<PFM::PokemonBattler>] all alive battlers
      def on_end_turn_event(logic, scene, battlers)
        return if affected_pokemon.dead?
        return if affected_pokemon.has_ability?(:magic_guard)
        return if affected_pokemon.type1 == @move.type || affected_pokemon.type2 == @move.type || affected_pokemon.type3 == @move.type

        logic.scene.display_message_and_wait(parse_text_with_pokemon(20_000, 8, affected_pokemon))
        logic.damage_handler.damage_change((affected_pokemon.max_hp / 6).clamp(1, Float::INFINITY), affected_pokemon)
      end

      # Get the name of the effect
      # @return [Symbol]
      def name
        return :damage_over_four_turns
      end

      # Function called when the effect has been deleted from the effects handler
      def on_delete
        @logic.scene.display_message_and_wait(parse_text(20_000, 11))
      end
    end
  end
end
