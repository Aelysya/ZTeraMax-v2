module Battle
  module Effects
    class DestinyBond < PokemonTiedEffectBase
      module ZTeraMaxPlugin
        # Function called after damages were applied and when target died (post_damage_death)
        # @param handler [Battle::Logic::DamageHandler]
        # @param hp [Integer] number of hp (damage) dealt
        # @param target [PFM::PokemonBattler]
        # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
        # @param skill [Battle::Move, nil] Potential move used
        def on_post_damage_death(handler, hp, target, launcher, skill)
          return if launcher.dynamaxed

          super
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
