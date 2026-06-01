module Battle
  class Move
    module ZTeraMaxPlugin
      # Method calculating the damages done by the actual move
      # @note : I used the 4th Gen formula : https://www.smogon.com/dp/articles/damage_formula
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @note The formula is the following:
      #       (((((((Level * 2 / 5) + 2) * BasePower * [Sp]Atk / 50) / [Sp]Def) * Mod1) + 2) *
      #         CH * Mod2 * R / 100) * STAB * Type1 * Type2 * Mod3)
      # @return [Integer]
      # rubocop:disable Metrics/MethodLength
      def damages(user, target)
        return super unless target.terastallized || user.terastallized

        # rubocop:disable Layout/ExtraSpacing
        # rubocop:disable Style/Semicolon
        # rubocop:disable Style/SpaceBeforeSemicolon
        log_data("# damages(#{user}, #{target}) for #{db_symbol}")
        # Reset the effectiveness
        @effectiveness = 1
        @critical = logic.calc_critical_hit(user, target, critical_rate)                   ; log_data("@critical = #{@critical} # critical_rate = #{critical_rate}")
        damage = user.level * 2 / 5 + 2                                                    ; log_data("damage = #{damage} # #{user.level} * 2 / 5 + 2")
        damage = (damage * calc_base_power(user, target)).floor                            ; log_data("damage = #{damage} # after calc_base_power")
        damage = (damage * calc_sp_atk(user, target)).floor / 50                           ; log_data("damage = #{damage} # after calc_sp_atk / 50")
        damage = (damage / calc_sp_def(user, target)).floor                                ; log_data("damage = #{damage} # after calc_sp_def")
        damage = (damage * calc_mod1(user, target)).floor + 2                              ; log_data("damage = #{damage} # after calc_mod1 + 2")
        damage = (damage * calc_ch(user, target)).floor                                    ; log_data("damage = #{damage} # after calc_ch")
        damage = (damage * calc_mod2(user, target)).floor                                  ; log_data("damage = #{damage} # after calc_mod2")
        damage *= logic.move_damage_rng.rand(calc_r_range)
        damage /= 100                                                                      ; log_data("damage = #{damage} # after rng")
        types = definitive_types(user, target)
        damage = (damage * calc_stab(user, types)).floor                                   ; log_data("damage = #{damage} # after stab")
        if target.terastallized && target.tera_type != data_type(:stellar).id
          damage = (damage * calc_tera_type_multiplier(target, types)).floor               ; log_data("damage = #{damage} # after tera type")
        else
          damage = (damage * calc_type_n_multiplier(target, :type1, types)).floor          ; log_data("damage = #{damage} # after type1")
          damage = (damage * calc_type_n_multiplier(target, :type2, types)).floor          ; log_data("damage = #{damage} # after type2")
          damage = (damage * calc_type_n_multiplier(target, :type3, types)).floor          ; log_data("damage = #{damage} # after type3")
        end
        if user.terastallized && user.tera_type == data_type(:stellar).id
          damage = (damage * calc_stellar_boost_multiplier(user, types)).floor             ; log_data("damage = #{damage} # after stellar boost")
        end
        damage = (damage * calc_mod3(user, target)).floor                                  ; log_data("damage = #{damage} # after mod3")
        target_hp = target.effects.get(:substitute).hp if target.effects.has?(:substitute) && !user.has_ability?(:infiltrator) && !authentic?
        target_hp ||= target.hp
        damage = damage.clamp(1, target_hp)                                                ; log_data("damage = #{damage} # after clamp")

        return damage
        # rubocop:enable Layout/ExtraSpacing
        # rubocop:enable Style/Semicolon
        # rubocop:enable Style/SpaceBeforeSemicolon
        # rubocop:enable Metrics/MethodLength
      end

      # STAB calculation
      # @param user [PFM::PokemonBattler] user of the move
      # @param types [Array<Integer>] list of definitive types of the move
      # @return [Numeric]
      def calc_stab(user, types)
        super unless user.terastallized

        has_tera_stab = types.any? { |type| user.tera_type == type }
        has_regular_stab = types.any? { |type| user.type1 == type || user.type2 == type || user.type3 == type }

        if has_tera_stab && has_regular_stab
          return 2.25 if user.has_ability?(:adaptability)

          return 2
        end

        return 2 if has_tera_stab && user.has_ability?(:adaptability)
        return 1.5 if has_tera_stab || has_regular_stab

        return 1
      end

      private

      # List of methods that should be ignored when applying base power boost of Terastallization
      IGNORED_BE_METHODS = %i[s_multi_hit s_2hits s_eruption s_wring_out s_return s_flail s_gyro_ball s_beat_up s_fling
                              s_electro_ball s_frustration s_low_kick s_heavy_slam s_psywave s_hp_eq_level s_hard_press
                              s_magnitude s_trump_card s_stored_power s_split_up s_present s_natural_gift]

      # Base power calculation
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def calc_base_power(user, target)
        return super unless user.terastallized

        base_power = super
        return 60 unless base_power >= 60 || IGNORED_BE_METHODS.include?(be_method)

        return base_power
      end

      # Calc Tera type multiplier of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @param types [Array<Integer>] list of types the move has
      # @return [Numeric]
      def calc_tera_type_multiplier(target, types)
        target_type = target.send(:tera_type)
        result = types.inject(1) { |product, type| product * calc_single_type_multiplier(target, target_type, type) }
        if @effectiveness >= 0
          @effectiveness *= result
          log_data("multiplier of Tera type (#{data_type(target_type).name}) = #{result} => new_eff = #{@effectiveness}")
        end
        return result
      end

      # Get the Stellar boost factor
      # @param user [PFM::PokemonBattler] user of the move
      # @param types [Array<Integer>] list of types the move has
      # @return [Numeric]
      def calc_stellar_boost_multiplier(user, types)
        return 1 if types.any? { |type| user.stellar_boosted_types.include?(type) }

        add_used_stellar_boosts(user, types)
        boost = types.any? { |type| user.type1 == type || user.type2 == type || user.type3 == type } ? 2 : 1.2
        log_data("Stellar boost applied: #{boost}")

        return boost
      end

      # Add the move's types to the list of used Stellar boosts
      # @param user [PFM::PokemonBattler] user of the move
      # @param types [Array<Integer>] list of types the move has
      # @note Terapagos is unaffected by this
      def add_used_stellar_boosts(user, types)
        return if user.db_symbol == :terapagos

        user.stellar_boosted_types << types
      end
    end
    prepend ZTeraMaxPlugin
  end
end
