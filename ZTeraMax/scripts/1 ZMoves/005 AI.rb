module Battle
  module AI
    class Base
      module ZTeraMaxPlugin
        # Try to find the battle action for a dedicated pokemon, extended to evaluate Z-Move candidates.
        # @param pokemon [PFM::PokemonBattler]
        # @return [Actions::Base, Array<Actions::Base>]
        def battle_action_for(pokemon)
          actions = usable_moves(pokemon).map { |move| move_action_for(move, pokemon) }
          move_heuristics = actions.compact.map(&:first)
          mega = mega_evolve_action_for(pokemon) if @can_mega_evolve
          z_actions = z_move_actions_for(pokemon) if @can_z_move
          actions.concat(z_actions) if z_actions
          force_switch = move_heuristics.all? { |heuristic| heuristic == 0 }
          actions.concat(clean_switch_trigger_actions(switch_actions_for(pokemon, move_heuristics), force_switch)) if @can_switch
          actions.concat(item_actions_for(pokemon, move_heuristics)) if @can_use_item
          actions.concat([flee_action_for(pokemon)].compact) if @can_flee

          debug_process_actions(actions) if respond_to?(:debug_process_actions)
          final_action = actions.compact.shuffle(random: @scene.logic.generic_rng).max_by(&:first)&.last
          pokemon.bag.remove_item(final_action.item_wrapper.item.db_symbol, 1) if final_action.is_a?(Actions::Item) && !ARGV.include?('ai_sim')
          mega = nil if final_action.is_a?(Actions::Switch)

          p actions
          # If Z-Move moveset was activated but a non-Z-Move action was ultimately chosen, revert.
          pokemon.reset_to_original_moveset if z_actions&.any? && !final_action.is_a?(Actions::ZMove)

          return mega ? [mega, final_action] : final_action
        end

        # Get Z-Move actions for the given Pokémon.
        # @param pokemon [PFM::PokemonBattler]
        # @return [Array<[Float, Actions::ZMove]>]
        def z_move_actions_for(pokemon)
          return [] unless @scene.logic.z_move.can_pokemon_use_z_move?(pokemon)

          @scene.logic.z_move.update_moveset(pokemon, true)
          z_actions = usable_moves(pokemon).filter_map { |move| z_move_action_for_move(move, pokemon) }
          pokemon.reset_to_original_moveset if z_actions.empty?

          return z_actions
        end

        # Score a Z-Move.
        # @param move [Battle::Move]
        # @param pokemon [PFM::PokemonBattler]
        # @return [Array(Float, Actions::ZMove), nil]
        def z_move_action_for_move(move, pokemon)
          targets = filter_targets(move.battler_targets(pokemon, @scene.logic), pokemon, move)
          return nil if targets.empty?

          candidates = targets.map do |battler|
            [move_heuristic(move, pokemon, battler), Actions::ZMove.new(@scene, move, pokemon, battler.bank, battler.position)]
          end
          candidates = group_move_action(candidates) unless move.one_target?

          return candidates.shuffle(random: @scene.logic.generic_rng).max_by(&:first)
        end
      end
      prepend ZTeraMaxPlugin
    end

    # Module that enables Z-Move usage for an AI level.
    module ZMoveCapability
      private

      def init_capability
        super
        @can_z_move = true
      end
    end

    TrainerLv4.prepend(ZMoveCapability)
    TrainerLv5.prepend(ZMoveCapability)
    TrainerLv6.prepend(ZMoveCapability)
    TrainerLv7.prepend(ZMoveCapability)
  end
end
