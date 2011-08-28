class MakeVotesUniquePerUser < ActiveRecord::Migration
  def self.up
    # from vote_fu
    # If you want to enforce "One Person, One Vote" rules in the database, uncomment the index below
    add_index :votes, ["voter_id", "voter_type", "voteable_id", "voteable_type"], :unique => true, :name => "uniq_one_vote_only"
  end

  def self.down
    remove_index :votes, :name => "uniq_one_vote_only"
  end
end
