module Battle
  class Logic
    # Extend BattleInfo to track each trainer's Studio database ID, indexed by [bank][party_id].
    # This allows config markers to reference trainers by their Studio ID rather than
    # the battle-relative party_id (which is always 0 for single-trainer battles).
    class BattleInfo
      # @return [Array<Array<Integer>>] trainer database IDs indexed by [bank][party_id]
      attr_accessor :trainer_db_ids

      module ZTeraMaxPlugin
        def initialize(hash = {})
          super
          @trainer_db_ids = [[], []]
        end
      end
      prepend ZTeraMaxPlugin

      class << self
        module ZTeraMaxPlugin
          def add_trainer(battle_info, bank, id_trainer)
            party_idx = (battle_info.parties[bank] || []).size
            super
            (battle_info.trainer_db_ids[bank] ||= [])[party_idx] = id_trainer
          end
        end
        prepend ZTeraMaxPlugin
      end
    end

    module ZTeraMaxPlugin
      # Get the ZMove helper
      # @return [ZMoves]
      attr_reader :z_move
      # Get the Dynamax helper
      # @return [Dynamax]
      attr_reader :dynamax
      # Get the Terastal helper
      # @return [Terastal]
      attr_reader :terastal

      # Create a new Logic instance
      # @param scene [Scene] scene that holds the logic object
      def initialize(scene)
        @z_move = ZMoves.new(scene)
        @dynamax = Dynamax.new(scene)
        @terastal = Terastal.new(scene)
        super
      end

      # Handle form recalibration after battle
      # @param players_creatures [Array<PFM::PokemonBattler>]
      def handle_form_recalibration(players_creatures)
        players_creatures.each(&:undynamax)
        players_creatures.each { |pokemon| pokemon.terastallized = false }
        super
      end
    end
    prepend ZTeraMaxPlugin

    class MegaEvolve
      private

      # Function that checks if any action of the player is a mega evolve
      # @return [Boolean]
      # @note The method has been overriden to avoid checking for an Array Action, which would return true if any Action was a Dynamax Action
      def any_mega_player_action?
        @scene.player_actions.flatten.any? { |actions| actions.is_a?(Actions::Mega) }
      end
    end
  end
end
