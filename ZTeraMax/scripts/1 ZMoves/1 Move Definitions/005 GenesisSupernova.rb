module Battle
  class Move
    # Move class for Genesis Supernova Z-Move
    class GenesisSupernova < ZMove
      private

      # Sets terrain to psychic terrain
      # @param _user [PFM::PokemonBattler] user of the move
      # @param _actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(_user, _actual_targets)
        logic.fterrain_change_handler.fterrain_change_with_process(:psychic_terrain, 5)
      end
    end
    Move.register(:s_genesis_supernova, GenesisSupernova)
  end
end
