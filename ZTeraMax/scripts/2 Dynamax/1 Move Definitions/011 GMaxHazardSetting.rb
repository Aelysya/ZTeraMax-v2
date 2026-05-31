module Battle
  class Move
    class GMaxStonesurge < MaxMove
      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        bank = actual_targets.map(&:bank).first

        return if @logic.bank_effects[bank]&.get(:stealth_rock)

        @logic.add_bank_effect(Effects::StealthRock.new(@logic, bank, self))
        @scene.display_message_and_wait(parse_text(18, 162 + user.bank.clamp(0, 1)))
      end

      # Calculate the multiplier needed to get the damage factor of the Stealth Rock
      # @param target [PFM::PokemonBattler]
      # @return [Integer, Float]
      def calc_factor(target)
        type = [data_type(:rock).id] # The move is Water type, so we have to do it like that
        @effectiveness = -1
        n = calc_type_n_multiplier(target, :type1, type) *
            calc_type_n_multiplier(target, :type2, type) *
            calc_type_n_multiplier(target, :type3, type)
        return n
      end
    end
    Move.register(:s_gmax_stonesurge, GMaxStonesurge)

    class GMaxSteelsurge < MaxMove
      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        bank = actual_targets.map(&:bank).first

        return if @logic.bank_effects[bank]&.get(:steel_spikes)

        @logic.add_bank_effect(Effects::SteelSpikes.new(@logic, bank, self))
        @scene.display_message_and_wait(parse_text(18, bank == 0 ? 162 : 163))
      end

      # Calculate the multiplier needed to get the damage factor of the Steel Spikes
      # @param target [PFM::PokemonBattler]
      # @return [Integer, Float]
      def calc_factor(target)
        type = [self.type]
        @effectiveness = -1
        n = calc_type_n_multiplier(target, :type1, type) *
            calc_type_n_multiplier(target, :type2, type) *
            calc_type_n_multiplier(target, :type3, type)
        return n
      end
    end
    Move.register(:s_gmax_steelsurge, GMaxSteelsurge)
  end
end
