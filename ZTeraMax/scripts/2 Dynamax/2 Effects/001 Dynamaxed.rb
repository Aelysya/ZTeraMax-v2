module Battle
  module Effects
    class Dynamaxed < PokemonTiedEffectBase
      # Create a new Pokemon tied effect
      # @param logic [Battle::Logic]
      # @param pokemon [PFM::PokemonBattler]
      def initialize(logic, pokemon)
        super
        @counter = 3
      end

      # Get the name of the effect
      # @return [Symbol]
      def name
        return :dynamaxed
      end

      # Function called when the effect has been deleted from the effects handler
      def on_delete
        return unless @pokemon.dynamaxed # Prevent rest of the method if the effect was killed by deactivating the Dynamax button

        @pokemon.undynamax

        # Don't play deflate animation if battler is dead or being switched
        return unless @pokemon.can_fight?

        visual = @logic.scene.visual
        sprite = visual.battler_sprite(@pokemon.bank, @pokemon.position)
        sprite.deflate_animation
        sprite.pokemon = @pokemon
      end

      # Function called when a Pokemon has actually switched with another one
      # @param handler [Battle::Logic::SwitchHandler]
      # @param who [PFM::PokemonBattler] Pokemon that is switched out
      # @param with [PFM::PokemonBattler] Pokemon that is switched in
      def on_switch_event(handler, who, with)
        kill if who == @pokemon
      end

      # Function called after damages were applied and when target died (post_damage_death)
      # @param handler [Battle::Logic::DamageHandler]
      # @param hp [Integer] number of hp (damage) dealt
      # @param target [PFM::PokemonBattler]
      # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
      # @param skill [Battle::Move, nil] Potential move used
      def on_post_damage_death(handler, hp, target, launcher, skill)
        kill if target == @pokemon
      end

      # Function called when a status_prevention is checked
      # @param handler [Battle::Logic::StatusChangeHandler]
      # @param status [Symbol] :poison, :toxic, :confusion, :sleep, :freeze, :paralysis, :burn, :flinch, :cure
      # @param target [PFM::PokemonBattler]
      # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
      # @param skill [Battle::Move, nil] Potential move used
      # @return [:prevent, nil] :prevent if the status cannot be applied
      def on_status_prevention(handler, status, target, launcher, skill)
        return unless status == :flinch

        return :prevent
      end

      MOVES_IMMUNITY = %i[sky_drop heat_crash heavy_slam grass_knot low_kick entrainment skill_swap]

      # Function called when we try to check if the Pokemon is immune to a move due to its effect
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler]
      # @param move [Battle::Move]
      # @return [Boolean] if the target is immune to the move
      def on_move_ability_immunity(user, target, move)
        return true if move&.ohko?
        return true if MOVES_IMMUNITY.include?(move.db_symbol)

        return false
      end
    end
  end
end
