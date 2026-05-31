module Battle
  module Effects
    class ChiStrike < PokemonTiedEffectBase
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :chi_strike
      end
    end
  end

  class Logic
    module ZTeraMaxPlugin
      # Calculate the critical count (to get the right critical propability)
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler]
      # @param initial_critical_count [Integer] Initial critical count of the move
      # @return [Integer]
      def calc_critical_count(user, target, initial_critical_count)
        critical_count = super
        return 0 if critical_count.zero?

        user.effects.each do |effect|
          critical_count += 1 if effect.name == :chi_strike # Chi Strike effect is stackable
        end
        return critical_count
      end
    end
    prepend ZTeraMaxPlugin
  end
end
