module Battle
  class Move
    class TerrainMaxMove < MaxMove
      TERRAIN_MOVES = {
        max_lightning: :electric_terrain,
        max_overgrowth: :grassy_terrain,
        max_starfall: :misty_terrain,
        max_mindstorm: :psychic_terrain
      }

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        turn_count = user.hold_item?(:terrain_extender) ? 8 : 5
        @logic.fterrain_change_handler.fterrain_change_with_process(TERRAIN_MOVES[db_symbol], turn_count)
      end
    end
    Move.register(:s_terrain_max_move, TerrainMaxMove)
  end
end
