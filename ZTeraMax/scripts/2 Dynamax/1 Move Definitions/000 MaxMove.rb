module Battle
  class Move
    class MaxMove < Basic
      # Original move linked to this Max Move
      # @return [Battle::Move]
      attr_reader :original_move

      # List of power depending on the original move for this Max Move
      MAX_MOVES_POWER = {
        struggle: 1,

        **%i[
          poison_sting acid smog mach_punch rock_smash arm_thrust vacuum_wave acid_spray power_up_punch
        ].each_with_object({}) do |action, hash|
          hash[action] = 70
        end,

        **%i[
          counter seismic_toss poison_fang poison_tail clear_smog
        ].each_with_object({}) do |action, hash|
          hash[action] = 75
        end,

        **%i[
          double_kick triple_kick revenge force_palm storm_throw circle_throw
        ].each_with_object({}) do |action, hash|
          hash[action] = 80
        end,

        **%i[
          sludge vital_throw cross_poison venoshock low_sweep
        ].each_with_object({}) do |action, hash|
          hash[action] = 85
        end,

        **%i[
          pound pay_day scratch gust bind fury_attack tackle wrap ember water_gun peck submission absorb
          mega_drain fire_spin thunder_shock quick_attack lick powder_snow sludge_bomb mud_slap rollout
          false_swipe fury_cutter dynamic_punch cross_chop twister whirlpool fake_out brick_break
          astonish sand_tomb hammer_arm feint aura_sphere poison_jab drain_punch bullet_punch ice_shard
          shadow_sneak aqua_jet sludge_wave echoed_voice sacred_sword secret_sword flying_press
          disarming_voice fairy_wind water_shuriken nuzzle hold_back infestation leafage accelerock
          body_press snap_trap branch_poke shell_side_arm thunderous_kick
        ].each_with_object({}) do |action, hash|
          hash[action] = 90
        end,

        **%i[
          high_jump_kick superpower close_combat focus_blast gunk_shot belch multi_attack
        ].each_with_object({}) do |action, hash|
          hash[action] = 95
        end,

        **%i[
          cut vine_whip low_kick rock_throw confusion night_shade fury_swipes super_fang snore reversal
          present rapid_spin metal_claw mirror_coat beat_up spit_up focus_punch metal_burst payback fling
          charge_beam smack_down flame_charge final_gambit struggle_bug fell_stinger draining_kiss
          nature_s_madness meteor_assault
        ].each_with_object({}) do |action, hash|
          hash[action] = 100
        end,

        **%i[
          vise_grip wing_attack bite razor_leaf swift thief flame_wheel icy_wind dragon_breath ancient_power
          air_cutter rock_tomb shadow_punch aerial_ace mud_shot covet magical_leaf shock_wave water_pulse pluck
          assurance avalanche bug_bite round incinerate acrobatics bulldoze frost_breath dragon_tail electroweb
          snarl brutal_swing breaking_swipe flip_turn
        ].each_with_object({}) do |action, hash|
          hash[action] = 110
        end,

        **%i[
          stomp headbutt horn_attack psybeam bubble_beam aurora_beam slash octazooka spark steel_wing facade knock_off
          luster_purge mist_ball brine u_turn sucker_punch night_slash shadow_claw thunder_fang ice_fang fire_fang
          psycho_cut chatter double_hit hex retaliate volt_switch leaf_tornado glaciate parabolic_charge freeze_dry
          smart_strike trop_kick grassy_glide skitter_smack burning_jealousy scorching_sands
        ].each_with_object({}) do |action, hash|
          hash[action] = 120
        end,

        **%i[
          mega_punch fire_punch ice_punch thunder_punch guillotine fly slam horn_drill body_slam take_down pin_missile
          flamethrower surf ice_beam drill_peck strength thunderbolt earthquake fissure dig psychic waterfall dream_eater
          leech_life crabhammer bonemerang rock_slide hyper_fang tri_attack flail aeroblast bone_rush giga_drain
          sacred_fire iron_tail crunch extreme_speed shadow_ball uproar heat_wave endeavor dive blaze_kick hyper_voice
          crush_claw meteor_mash weather_ball extrasensory sheer_cold muddy_water bullet_seed icicle_spear dragon_claw
          bounce leaf_blade rock_blast gyro_ball dark_pulse aqua_tail seed_bomb air_slash x_scissor bug_buzz dragon_pulse
          dragon_rush power_gem energy_ball earth_power zen_headbutt flash_cannon discharge lava_plume iron_head stone_edge
          grass_knot judgment attack_order spacial_rend magma_storm psyshock heavy_slam electro_ball foul_play stored_power
          scald inferno water_pledge fire_pledge grass_pledge wild_charge drill_run dual_chop horn_leech razor_shell
          heat_crash night_daze psystrike tail_slap gear_grind searing_shot relic_song fiery_dance icicle_crash fusion_flare
          fusion_bolt phantom_force petal_blizzard play_rough moonblast diamond_storm hyperspace_hole mystical_fire
          dazzling_gleam oblivion_wing thousand_arrows thousand_waves land_s_wrath hyperspace_fury first_impression
          spirit_shackle darkest_lariat sparkling_aria ice_hammer high_horsepower throat_chop pollen_puff anchor_shot lunge
          fire_lash power_trip revelation_dance core_enforcer beak_blast dragon_hammer psychic_fangs stomping_tantrum
          shadow_bone liquidation spectral_thief sunsteel_strike moongeist_beam zing_zap plasma_fists photon_geyser snipe_shot
          jaw_lock dragon_darts bolt_beak fishious_rend drum_beating behemoth_blade behemoth_bash overdrive apple_acid
          grav_apple spirit_break strange_steam false_surrender expanding_force scale_shot misty_explosion terrain_pulse
          lash_out dual_wingbeat wicked_blow surging_strikes thunder_cage freezing_glare fiery_wrath eerie_spell
        ].each_with_object({}) do |action, hash|
          hash[action] = 130
        end,

        **%i[
          mega_kick thrash double_edge hydro_pump blizzard solar_beam petal_dance thunder fire_blast skull_bash
          sky_attack zap_cannon outrage megahorn future_sight overheat volt_tackle doom_desire psycho_boost last_resort
          flare_blitz brave_bird draco_meteor leaf_storm power_whip wood_hammer crush_grip seed_flare shadow_force
          hurricane head_charge techno_blast bolt_strike blue_flare freeze_shock ice_burn boomburst steam_eruption
          light_of_ruin origin_pulse precipice_blades dragon_ascent solar_blade burn_up clanging_scales fleur_cannon
          double_iron_bash dynamax_cannon pyro_ball aura_wheel steel_beam steel_roller meteor_beam rising_voltage
          poltergeist triple_axel glacial_lance astral_barrage
        ].each_with_object({}) do |action, hash|
          hash[action] = 140
        end,

        **%i[
          hyper_beam self_destruct explosion eruption blast_burn hydro_cannon water_spout frenzy_plant giga_impact
          rock_wrecker head_smash roar_of_time v_create shell_trap prismatic_laser mind_blown eternabeam dragon_energy
        ].each_with_object({}) do |action, hash|
          hash[action] = 150
        end
      }

      # List of Max Moves that have a fixed power, no matter the original move
      FIXED_POWER_MAX_MOVE = {
        gmax_drum_solo: 160,
        gmax_fireball: 160,
        gmax_hydrosnipe: 160
      }

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      # @param original_move [Battle::Move] original move linked to this Max Move
      def initialize(db_symbol, scene, original_move)
        @original_move = original_move
        @is_max = true
        super(db_symbol, original_move.pp, original_move.ppmax, scene)
      end

      # Is the skill physical ?
      # @return [Boolean]
      def physical?
        return original_move.physical?
      end

      # Is the skill special ?
      # @return [Boolean]
      def special?
        return original_move.special?
      end

      # Calculates the real base power of a move considering original move power.
      # If a move is not in the Hash (9G+ moves) the power fallsback to 130 by default
      # @param user [PFM::PokemonBattler] The user of the move.
      # @param target [PFM::PokemonBattler] The target of the move.
      # @return [Integer] The calculated base power of the move.
      # @see https://bulbapedia.bulbagarden.net/wiki/Max_Move#Power
      # The calculated power is then logged and returned.
      def real_base_power(_user, _target)
        power = FIXED_POWER_MAX_MOVE.fetch(db_symbol, MAX_MOVES_POWER.fetch(@original_move.db_symbol, 130))

        log_data("power = #{power} # after #{self.class} real_base_power")
        return power
      end

      # Checks if the move overwhelms protected targets and does some damage through protect-like effects
      # @return [Boolean] If the move is overwhelming
      def overwhelms_protect?
        # These two moves completely bypass protect-like effects
        return false if %i[gmax_one_blow gmax_rapid_flow].include?(db_symbol)

        return true
      end
    end
    Move.register(:s_max_move, MaxMove)
  end
end
