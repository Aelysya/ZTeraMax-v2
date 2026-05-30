module Battle
  class Logic
    class ItemChangeHandler < ChangeHandlerBase
      # List of item that cannot be manipulated during battle (Knock off, Trick, etc...)
      PROTECTED_ITEMS.concat(%i[normalium_z fightinium_z flyinium_z poisonium_z groundium_z rockium_z buginium_z
                                ghostium_z steelium_z firium_z waterium_z grassium_z electrium_z psychium_z
                                icium_z dragonium_z darkinium_z fairium_z aloraichium_z decidium_z eevium_z
                                incinium_z kommonium_z lunalium_z lycanium_z marshadium_z mewnium_z mimikium_z
                                pikanium_z pikashunium_z primarium_z snorlium_z solganium_z tapunium_z ultranecrozium_z])
    end
  end
end

module Util
  module GiveTakeItem
    module ZTeraMaxPlugin
      # List of Z crystals IDs associations, key is the big crystal, value is the held crystal
      Z_CRYSTALS_IDS = {
        807 => 776, # Normalium Z
        808 => 777, # Firium Z
        809 => 778, # Waterium Z
        810 => 779, # Electrium Z
        811 => 780, # Grassium Z
        812 => 781, # Icium Z
        813 => 782, # Fightinium Z
        814 => 783, # Poisonium Z
        815 => 784, # Groundium Z
        816 => 785, # Flyinium Z
        817 => 786, # Psychium Z
        818 => 787, # Buginium Z
        819 => 788, # Rockium Z
        820 => 789, # Ghostium Z
        821 => 790, # Dragonium Z
        822 => 791, # Darkinium Z
        823 => 792, # Steelium Z
        824 => 793, # Fairium Z
        825 => 794, # Pikanium Z
        826 => 798, # Decidium Z
        827 => 799, # Incinium Z
        828 => 800, # Primarium Z
        829 => 801, # Tapunium Z
        830 => 802, # Marshadium Z
        831 => 803, # Aloraichium Z
        832 => 804, # Snorlium Z
        833 => 805, # Eevium Z
        834 => 806, # Mewnium Z
        836 => 835, # Pikashunium Z
        1118 => 1112, # Solganium Z
        1119 => 1113, # Lunalium Z
        1120 => 1114, # Ultranecrozium Z
        1121 => 1115, # Mimikium Z
        1122 => 1116, # Lycanium Z
        1123 => 1117 # Kommonium Z
      }

      # Update the bag and pokemon state when giving an item
      # @param item1 [Integer] taken item
      # @param item2 [Integer] given item
      # @param pokemon [PFM::Pokemon] Pokemong getting the item
      # @note The code is strangely written, but no other thing seems to work without crashing the game at some point
      def givetake_give_item_update_state(item1, item2, pokemon)
        return super unless Z_CRYSTALS_IDS.key?(item2)

        pokemon.item_holding = Z_CRYSTALS_IDS[item2]
        $bag.add_item(item1, 1) unless item1 == 0 || Z_CRYSTALS_IDS.value?(item1)
      end

      # Action of taking the item from the Pokemon
      # @param pokemon [PFM::Pokemon] pokemon we take item from
      # @yieldparam pokemon [PFM::Pokemon] block we call with pokemon before and after the form calibration
      def givetake_take_item(pokemon)
        item = pokemon.item_holding
        $bag.add_item(item, 1) unless Z_CRYSTALS_IDS.value?(item)
        pokemon.item_holding = 0
        yield(pokemon) if block_given?
        display_message(parse_text_with_pokemon(23, 78, pokemon, ::PFM::Text::ITEM2[1] => data_item(item).name))
        return unless pokemon.form_calibrate # Form ajustment

        pokemon.hp = (pokemon.max_hp * pokemon.hp_rate).round
        yield(pokemon) if block_given?
        display_message(parse_text_with_pokemon(22, 157, pokemon))
      end
    end
    prepend ZTeraMaxPlugin
  end
end
