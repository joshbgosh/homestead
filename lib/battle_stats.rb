class BattleStats
  class NoPriorVotes < BattleStats
  end

  class PriorVotes < BattleStats
    attr_accessor :user_picked, :percent_agreed, :percent_disagreed

    def initialize(users_pick, wins, losses)
      @user_picked = users_pick
      
      previous_wins = wins - 1
      previous_losses = losses
      previous_battles = previous_wins + previous_losses
      
      @percent_agreed = previous_wins / previous_battles.to_f * 100
      @percent_disagreed = previous_losses / previous_battles.to_f * 100
    end
  end
end




