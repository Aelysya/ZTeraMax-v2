module Battle
  class Move
    class WeatherMaxMove < MaxMove
      WEATHER_MOVES = {
        max_geyser: :rain,
        max_flare: :sunny,
        max_rockfall: :sandstorm,
        max_hailstorm: :hail
      }
      WEATHER_ITEMS = {
        rain_dance: :damp_rock,
        sunny_day: :heat_rock,
        sandstorm: :smooth_rock,
        hail: :icy_rock
      }

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        nb_turn = user.hold_item?(WEATHER_ITEMS[db_symbol]) ? 8 : 5
        @logic.weather_change_handler.weather_change_with_process(WEATHER_MOVES[db_symbol], nb_turn)
      end
    end
    Move.register(:s_weather_max_move, WeatherMaxMove)
  end
end
