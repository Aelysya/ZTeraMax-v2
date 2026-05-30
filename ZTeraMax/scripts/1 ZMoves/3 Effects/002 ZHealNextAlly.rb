module Battle
  module Effects
    class ZHealNextAlly < PokemonTiedEffectBase
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :z_heal_next_ally
      end

      # Function called when a Pokemon has actually switched with another one
      # @param handler [Battle::Logic::SwitchHandler]
      # @param who [PFM::PokemonBattler] Pokemon that is switched out
      # @param with [PFM::PokemonBattler] Pokemon that is switched in
      def on_switch_event(handler, who, with)
        handler.logic.damage_handler.heal(with, with.max_hp, test_heal_block: false)
      end
    end
  end
end
