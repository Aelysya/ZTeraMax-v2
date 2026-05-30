module Battle
  class Move
    # Class managing type-specific Z-Moves
    class TypeZMove < ZMove
      # Original move linked to this Z-Move
      # @return [Battle::Move]
      attr_reader :original_move

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param scene [Battle::Scene] current battle scene
      # @param original_move [Battle::Move] original move linked to this Z-Move
      def initialize(db_symbol, scene, original_move)
        @original_move = original_move
        super(db_symbol, original_move.pp, original_move.ppmax, scene)
      end

      # List of exceptions for the power calculation
      Z_MOVES_POWER_EXCEPTIONS = {
        struggle: 1,
        mega_drain: 120,
        weather_ball: 160,
        hex: 160,
        v_create: 220,
        flying_press: 170,
        core_enforcer: 140,
        electro_ball: 160,
        gyro_ball: 160,
        endeavor: 160,
        final_gambit: 180,
        frustration: 160,
        return: 160,
        heat_crash: 160,
        heavy_slam: 160,
        natural_gift: 160,
        punishment: 160,
        fissure: 180,
        guillotine: 180,
        horn_drill: 180,
        sheer_cold: 180,
        crush_grip: 190,
        wring_out: 190,
        hard_press: 180
      }

      # Calculates the real base power of a move considering Z-Move exceptions and original move power.
      # @param user [PFM::PokemonBattler] The user of the move.
      # @param target [PFM::PokemonBattler] The target of the move.
      # @return [Integer] The calculated base power of the move.
      # @see https://bulbapedia.bulbagarden.net/wiki/Z-Move#Power
      # The calculated power is then logged and returned.
      def real_base_power(_user, _target)
        z_power = if Z_MOVES_POWER_EXCEPTIONS.key?(@original_move.db_symbol)
                    Z_MOVES_POWER_EXCEPTIONS[@original_move.db_symbol]
                  else
                    case @original_move.base_power
                    when 0..59 then 100
                    when 60..69 then 120
                    when 70..79 then 140
                    when 80..89 then 160
                    when 90..99 then 175
                    when 100..109 then 180
                    when 110..119 then 185
                    when 120..129 then 190
                    when 130..139 then 195
                    else 200
                    end
                  end

        log_data("Z-Power = #{z_power} # after Z-Move power computation")
        return z_power
      end
    end
    Move.register(:s_type_z_move, TypeZMove)
  end
end
