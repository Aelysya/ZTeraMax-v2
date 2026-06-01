module Battle
  module Actions
    # Class describing the Terastal action
    class Terastal < Base
      # Get the user of this action
      # @return [PFM::PokemonBattler]
      attr_reader :user

      # Create a new Terastal action
      # @param scene [Battle::Scene]
      # @param user [PFM::PokemonBattler]
      def initialize(scene, user)
        super(scene)
        @user = user
      end

      # Compare this action with another
      # @param other [Base] other action
      # @return [Integer]
      def <=>(other)
        return 1 if other.is_a?(HighPriorityItem)
        return 1 if other.is_a?(Attack) && Attack.from(other).pursuit_enabled
        return 1 if other.is_a?(Item)
        return 1 if other.is_a?(Switch)
        return Terastal.from(other).user.spd <=> @user.spd if other.is_a?(Terastal)

        return -1
      end

      # Execute the action
      def execute
        @scene.logic.terastal.mark_as_terastal_used(@user)
        @user.terastallized = true
        $game_switches[Configs.z_tera_max.dynamax_enabled_switch] = false if $game_switches[Configs.z_tera_max.tera_orb_charge_enabled_switch]
        handle_form_change

        message = parse_text_with_pokemon(20_000, 15, @user, PFM::Text::PKNAME[0] => @user.given_name, '[VAR 0103(0001)]' => data_type(@user.tera_type).name)
        @scene.display_message_and_wait(message)
      end

      # List of Pokémon species that should change form when Terastallized
      # @return [Array<Symbol>]
      TERASTAL_REACTIVE_SPECIES = %i[ogerpon terapagos]

      # Change the form of Terapagos and Ogerpon
      def handle_form_change
        return unless TERASTAL_REACTIVE_SPECIES.include?(@user.db_symbol)

        @user.form_calibrate(:terastal)
        @scene.visual.show_switch_form_animation(@user)

        @user.ability = data_ability(@user.data.abilities.sample).id
        @user.ability_effect.on_switch_event(@scene.logic.switch_handler, @user, @user)
      end
    end
  end
end
