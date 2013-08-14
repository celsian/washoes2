class Game < ActiveRecord::Base
  has_many :game_players, dependent: :destroy

  has_many :players, through: :game_players
  belongs_to :winner, class_name: "Player"
  belongs_to :bracket

  accepts_nested_attributes_for :game_players

  def set_winner(player)
    self.winner = player
    if self.save
      return true
    else
      return false
    end
  end

  def to_a
    output = []

    if self.game_players.first.player_id
      output << self.game_players.first.player.name
      output << self.game_players.first.player.bracket_points(self.bracket)
    else
      output << "???"
      output << "?"
    end
    
    if self.game_players.last.player_id
      output << self.game_players.last.player.name
      output << self.game_players.last.player.bracket_points(self.bracket)
    else
      output << "???"
      output << "?"
    end

    return output
  end

end
