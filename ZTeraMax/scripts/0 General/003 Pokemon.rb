module PFM
  class Pokemon
    module ZTeraMaxPlugin
      # List of species with a fixed Tera type
      # @return [Array<Symbol>]
      FIXED_TERA_TYPE_SPECIES = %i[ogerpon terapagos]

      # Create a new Pokemon with specific parameters
      # @param id [Integer, Symbol] ID of the Pokemon in the database
      # @param level [Integer] level of the Pokemon
      # @param force_shiny [Boolean] if the Pokemon have 100% chance to be shiny
      # @param no_shiny [Boolean] if the Pokemon have 0% chance to be shiny (override force_shiny)
      # @param form [Integer] Form index of the Pokemon (-1 = automatic generation)
      # @param opts [Hash] Hash describing optional value you want to assign to the Pokemon
      # @option opts [Integer] :dynamax_level Dynamax level of the Pokemon
      # @option opts [Boolean] :gigantamax If the Pokemon has the Gigantamax factor
      # @option opts [Symbol] :tera_type Tera type of the Pokemon
      def initialize(id, level, force_shiny = false, no_shiny = false, form = -1, opts = {})
        super
        dynamax_initialize(opts)
        terastal_initialize(opts)
      end

      # Method that initialize the Dynamax values
      # @param opts [Hash] Hash describing optional value you want to assign to the Pokemon
      def dynamax_initialize(opts)
        @dynamax_level = opts[:dynamax_level] || 0

        @gigantamax_factor = if db_symbol == :eternatus
                               true
                             else
                               opts[:gigantamax] || rand(100) < Configs.z_tera_max.gigantamax_chance # 10% by default
                             end
      end

      # Method that initialize the Terastal values
      # @param opts [Hash] Hash describing optional value you want to assign to the Pokemon
      def terastal_initialize(opts)
        return handle_fixed_tera_type(opts) if FIXED_TERA_TYPE_SPECIES.include?(db_symbol)

        return @tera_type = data_type(opts[:tera_type]).id if opts[:tera_type]
        return @tera_type = rand(1..each_data_type.size) if rand(100) < Configs.z_tera_max.exotic_tera_type_chance # 10% by default
        return @tera_type = type1 if type2 == 0

        @tera_type = [type1, type2].sample
      end

      # Change the Tera type of the Pokemon
      # @param db_symbol [Symbol] db_symbol of the type
      def change_tera_type(type)
        @tera_type = data_type(type).id
      end

      # Get the Tera type of the Pokemon
      # @return [Integer]
      def tera_type
        return @tera_type || data_type(:normal).id
      end

      # Handle the fixed Tera type of Ogerpon and Terapagos
      # @param opts [Hash] Hash describing optional value you want to assign to the Pokemon
      def handle_fixed_tera_type(opts)
        return @tera_type = data_type(:stellar).id if db_symbol == :terapagos
        return @tera_type = data_type(:grass).id unless opts[:item]

        case opts[:item]
        when :wellspring_mask
          @tera_type = data_type(:water).id
        when :hearthflame_mask
          @tera_type = data_type(:fire).id
        when :cornerstone_mask
          @tera_type = data_type(:rock).id
        else
          @tera_type = data_type(:grass).id
        end
      end

      # Check if the Pokemon can mega evolve
      # @return [Integer, false] form index if the Pokemon can mega evolve, false otherwise
      # @note item-less Mega Evolution can't Mega if they hold a Z-Crystal (Rayquaza)
      def can_mega_evolve?
        return false if holds_z_crystal?

        super
      end
    end
    prepend ZTeraMaxPlugin

    # List of Z-Crystals
    # @return [Array<Symbol>]
    Z_CRYSTALS = %i[normalium_z fightinium_z flyinium_z poisonium_z groundium_z rockium_z buginium_z
                    ghostium_z steelium_z firium_z waterium_z grassium_z electrium_z psychium_z
                    icium_z dragonium_z darkinium_z fairium_z aloraichium_z decidium_z eevium_z
                    incinium_z kommonium_z lunalium_z lycanium_z marshadium_z mewnium_z mimikium_z
                    pikanium_z pikashunium_z primarium_z snorlium_z solganium_z tapunium_z ultranecrozium_z]

    # List of Z-Crystals that can change Arceus's form
    # @return [Array<Symbol>]
    ARCEUS_Z_CRYSTALS = %i[normalium_z firium_z waterium_z electrium_z grassium_z
                           icium_z fightinium_z poisonium_z groundium_z flyinium_z
                           psychium_z buginium_z rockium_z ghostium_z dragonium_z
                           steelium_z darkinium_z fairium_z]

    # @return [Integer] Dynamax level of the Pokémon between 0 and 10
    attr_accessor :dynamax_level

    # @return [Boolean] If the Pokémon has the Gigantamax factor
    attr_accessor :gigantamax_factor

    # Reset the Pokémon's moveset to its original state
    # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
    def reset_to_original_moveset
      effects.get(:dynamaxed)&.kill
      effects.get(:z_power)&.kill

      original_moveset.each_with_index do |move, i|
        moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, moveset[i].pp, move.ppmax, @scene)
      end
    end

    # Check if the Pokémon holds a Z-Crystal item
    # @return [Boolean] If the Pokémon holds a Z-Crystal
    def holds_z_crystal?
      return Z_CRYSTALS.include?(battle_item_db_symbol)
    end

    # Change Arceus's form based on its held item
    FORM_CALIBRATE[:arceus] = proc do
      next @form = ArceusItem.index(item_db_symbol).to_i if ArceusItem.include?(item_db_symbol)
      next @form = ARCEUS_Z_CRYSTALS.index(item_db_symbol).to_i if ARCEUS_Z_CRYSTALS.include?(item_db_symbol)

      next 0
    end
  end
end
