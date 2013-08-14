class Bracket < ActiveRecord::Base
  has_many :game_players, dependent: :destroy
  has_many :games, dependent: :destroy

  has_many :players, through: :game_players


  belongs_to :winner, class_name: "Player"
  belongs_to :user

  validates :name, :presence => { :message => " is required." }
  validates_uniqueness_of :name, :scope => :user_id

  def initial_create player_array
    #shuffles the players twice to randomize matchups.
    player_array.shuffle!
    player_array.shuffle!

    #Setting the total bracket size based on participant count
    if player_array.length == 4
      games = 3
    elsif player_array.length <= 8
      games = 7
    elsif player_array.length <= 16
      games = 15
    end

    #Creates ALL games for the bracket.
    0.upto(games-1) do |x|
      game = Game.create(bracket: self)
      0.upto(1) do |y|
        game_player = GamePlayer.new(bracket: self, game: game)
        game_player.points.build
        game_player.save
      end
    end
    
    #Grabs all games from the current bracket
    games = self.games

    #For all the games, each game gets 2 GamePlayers
    0.upto(games.length-1) do |game_position|
      0.upto(1) do |x|
        if player_array.length > 0 #ensures the GamePlayer will have a player.
          game_player = self.games[game_position].game_players[x]
          game_player.update_attributes(player_id: player_array.pop)
          game_player.save
        end
      end
    end
  end

  def fill_losers
    losers = []

    self.games.each do |game|
      if game.winner
        if game.winner == game.game_players.first.player
          if !losers.include?(game.game_players.last.player)
            losers << game.game_players.last.player
          end
        else
          if !losers.include?(game.game_players.first.player)
            losers << game.game_players.first.player
          end
        end
        if losers.include?(game.winner)
          losers = losers.delete_if{|player| game.winner == player}
        end
      else
        if game.game_players.first.player_id
          losers = losers.delete_if{|player| game.game_players.first.player == player}
        end
        if game.game_players.last.player_id
          losers = losers.delete_if{|player| game.game_players.last.player == player}
        end
      end
    end

    fill = []
    0.upto(((self.games.count+1)/2)-1) do |game_position|
      if self.games[game_position].game_players.first.player_id && self.games[game_position].game_players.last.player_id && self.games[game_position].winner
        fill = 1
      elsif self.games[game_position].game_players.first.player_id && self.games[game_position].game_players.last.player_id && !self.games[game_position].winner
        fill = 0
        break
      end
    end

    if fill == 1
      fill_losers_loop(self.games.count, losers)
    end
  end

  #New method for game_player filling during new bracket
  def fill_losers_loop games_count, losers
    losers.shuffle!

    # fills in blank games with losers from completed games in the bracket
    0.upto(((games_count+1)/2)-1) do |game_position|
        if !self.games[game_position].game_players.first.player_id && !self.games[game_position].game_players.last.player_id && losers.length >= 2 && !self.games[game_position].winner
          game_player = self.games[game_position].game_players.first
          game_player.update_attributes(player: losers.pop)
          game_player.save
          game_player = self.games[game_position].game_players.last
          game_player.update_attributes(player: losers.pop)
          game_player.save

        elsif self.games[game_position].game_players.first.player_id && !self.games[game_position].game_players.last.player_id && losers.length > 0
          game_player = self.games[game_position].game_players.last
          game_player.update_attributes(player: losers.pop)
          game_player.save
        end
    end
  end

  def winner_check
    0.upto(self.games.length-1) do |position|
      if self.games.last.winner
        self.winner = self.games.last.winner
        self.save
      elsif self.games[position].winner
        new_game_position = (((self.games.length+1)/2) + ((position+1).to_f/2).ceil)-1

        if position % 2 == 0 && !self.games[new_game_position].game_players.first.player_id
          game_player = self.games[new_game_position].game_players.first
          game_player.update_attributes(player: self.games[position].winner)
          game_player.save
        elsif position % 2 == 1 && !self.games[new_game_position].game_players.last.player_id
          game_player = self.games[new_game_position].game_players.last
          game_player.update_attributes(player: self.games[position].winner)
          game_player.save
        end
      end
    end
  end

  def players_array
    players_array = []
    self.players.each do |player|
      players_array << player.name
    end
    players_array.uniq!
    return players_array
  end

end