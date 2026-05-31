module Battle
  class Move
    class MaxGuard < Protect
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

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        actual_targets.each do |target|
          target.effects.add(Effects::Protect.new(logic, target, self))
          scene.display_message_and_wait(deal_message(target))
        end
      end
    end
    Move.register(:s_max_guard, MaxGuard)
  end
end
