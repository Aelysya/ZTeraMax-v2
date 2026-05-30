module Battle
  class Move
    # rubocop:disable Naming/VariableNumber
    # List of status moves that have an effect when used with a Z-Crystal
    Z_STATUS_MOVES_EFFECTS = {
      # Attack
      **%i[
        tail_whip
        leer
        meditate
        screech
        sharpen
        will_o_wisp
        taunt
        odor_sleuth
        howl
        bulk_up
        power_trick
        hone_claws
        work_up
        rototiller
        topsy_turvy
        laser_focus
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:atk, 1, user, scene) }
      end,

      **%i[
        mirror_move
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:atk, 2, user, scene) }
      end,

      **%i[
        splash
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:atk, 3, user, scene) }
      end,

      # Defense
      **%i[
        growl
        roar
        poison_powder
        toxic
        harden
        withdraw
        reflect
        poison_gas
        spider_web
        spikes
        charm
        pain_split
        torment
        feather_dance
        tickle
        block
        toxic_spikes
        aqua_ring
        stealth_rock
        defend_order
        wide_guard
        quick_guard
        mat_block
        noble_roar
        flower_shield
        grassy_terrain
        fairy_lock
        play_nice
        spiky_shield
        venom_drench
        baby_doll_eyes
        baneful_bunker
        strength_sap
        tearful_look
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:dfe, 1, user, scene) }
      end,

      # Special Attack
      **%i[
        growth
        confuse_ray
        mind_reader
        nightmare
        sweet_kiss
        teeter_dance
        fake_tears
        metal_sound
        gravity
        miracle_eye
        embargo
        telekinesis
        soak
        simple_beam
        reflect_type
        ion_deluge
        electrify
        gear_up
        psychic_terrain
        instruct
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:ats, 1, user, scene) }
      end,

      **%i[
        psycho_shift
        heal_block
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:ats, 2, user, scene) }
      end,

      # Special Defense
      **%i[
        whirlwind
        stun_spore
        thunder_wave
        light_screen
        glare
        mean_look
        flatter
        charge
        wish
        ingrain
        mud_sport
        cosmic_power
        water_sport
        wonder_room
        magic_room
        entrainment
        crafty_shield
        misty_terrain
        confide
        eerie_impulse
        magnetic_flux
        spotlight
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:dfs, 1, user, scene) }
      end,

      **%i[
        magic_coat
        imprison
        captivate
        aromatic_mist
        powder
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:dfs, 2, user, scene) }
      end,

      # Speed
      **%i[
        sing
        supersonic
        sleep_powder
        string_shot
        hypnosis
        lovely_kiss
        scary_face
        lock_on
        sandstorm
        safeguard
        encore
        rain_dance
        sunny_dance
        hail
        role_play
        yawn
        skill_swap
        grass_whistle
        gastro_acid
        power_swap
        guard_swap
        worry_seed
        guard_split
        power_split
        after_you
        quash
        sticky_web
        electric_terrai
        toxic_thread
        speed_swap
        aurora_veil
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:spd, 1, user, scene) }
      end,

      **%i[
        trick
        recycle
        snatch
        switcheroo
        ally_switch
        bestow
        me_first
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:spd, 2, user, scene) }
      end,

      # Accuracy
      **%i[
        mimic
        defense_curl
        focus_energy
        sweet_scent
        defog
        trick_room
        copycat
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:acc, 1, user, scene) }
      end,

      # Evasion
      **%i[
        sand_attack
        smokescreen
        kinesis
        flash
        detect
        camouflage
        lucky_chant
        magnet_rise
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { apply_stat_change(:eva, 1, user, scene) }
      end,

      # All basic stats
      **%i[
        conversion
        sketch
        trick_or_treat
        forest_s_curse
        geomancy
        happy_hour
        celebrate
        hold_hands
        purify
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { increase_all_stats(user, scene) }
      end,

      # Reset decreased stats
      **%i[
        swords_dance
        disable
        leech_seed
        agility
        double_team
        recover
        minimize
        barrier
        amnesia
        soft_boiled
        spore
        acid_armor
        rest
        substitute
        cotton_spore
        protect
        perish_song
        endure
        swagger
        milk_drink
        attract
        baton_pass
        morning_sun
        synthesis
        moonlight
        swallow
        follow_me
        helping_hand
        tail_glow
        slack_off
        iron_defense
        calm_mind
        dragon_dance
        roost
        rock_polish
        nasty_plot
        heal_order
        dark_void
        autotomize
        rage_powder
        quiver_dance
        coil
        shell_smash
        heal_pulse
        shift_gear
        cotton_guard
        king_s_shield
        shore_up
        floral_healing
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { reset_decreased_stats(user, scene) }
      end,

      # Focus attention
      **%i[
        destiny_bond
        grudge
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { focus_attention(user, scene) }
      end,

      # Boost crit ratio
      **%i[
        foresight
        tailwind
        acupressure
        heart_swap
        sleep_talk
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { boost_crit_ratio(user, scene) }
      end,

      # Full heal
      **%i[
        mist
        teleport
        haze
        transform
        conversion_2
        spite
        belly_drum
        heal_bell
        psych_up
        stockpile
        refresh
        aromatherapy
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, test_heal_block: false) }
      end,

      # Heal on next switch-in
      **%i[
        memento
        parting_shot
      ].each_with_object({}) do |action, hash|
        hash[action] = ->(user, scene) { user.effects.add(Effects::ZHealNextAlly.new(scene.logic, user)) }
      end,

      # Other
      curse: ->(user, scene) { z_curse(user, scene) }
    }
    # rubocop:enable Naming/VariableNumber

    # Function that handles the Z-effect of increasing one of the user's stats by 1 stage
    # @param user [PFM::PokemonBattler] user of the move
    # @param scene [battle::scene] scene of the battle
    def apply_stat_change(stat, value, user, scene)
      scene.logic.stat_change_handler.stat_change_with_process(stat, value, user, user, self)
    end

    # Function that handles the Z-effect of increasing all user's stats by 1 stage
    # @param user [PFM::PokemonBattler] user of the move
    # @param scene [battle::scene] scene of the battle
    def increase_all_stats(user, scene)
      scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self)
      scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self)
      scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self)
      scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self)
      scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self)
    end

    # Function that handles the Z-effect of resetting negative changes on the user's stats
    # @param user [PFM::PokemonBattler] user of the move
    # @param scene [battle::scene] scene of the battle
    def reset_decreased_stats(user, scene)
      return if user.battle_stage.none? { |stage| stage < 0 }

      user.battle_stage.map! { |stage| stage < 0 ? 0 : stage }
      scene.display_message_and_wait(parse_text_with_pokemon(19, 195, user))
    end

    # Function that handles the Z-effect of focusing the attention on the user
    # @param user [PFM::PokemonBattler] user of the move
    # @param scene [battle::scene] scene of the battle
    def focus_attention(user, scene)
      user.effects.add(Effects::CenterOfAttention.new(@logic, user, 1, self))
      scene.display_message_and_wait(parse_text_with_pokemon(19, 670, user))
    end

    # Function that handles the Z-effect of increasing the crit ratio of the user
    # @param user [PFM::PokemonBattler] user of the move
    # @param scene [battle::scene] scene of the battle
    def boost_crit_ratio(user, scene)
      return if %i[dragon_cheer focus_energy].any? { |e| user.effects.has?(e) }

      user.effects.add(Effects::FocusEnergy.new(@logic, user))
      scene.display_message_and_wait(parse_text_with_pokemon(19, 1047, user))
    end

    # Function that handles the Z-effect of Curse
    # @param user [PFM::PokemonBattler] user of the move
    # @param scene [battle::scene] scene of the battle
    def z_curse(user, scene)
      if user.type_ghost?
        scene.logic.damage_handler.heal(user, user.max_hp)
      else
        apply_stat_change(:atk, 1, user, scene)
      end
    end
  end
end
