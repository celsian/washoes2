class GamesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @games = Game.all
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
    @point = Point.new
    @game_form = Game.new

    check_winner
  end

  def new
    @game = Game.new
    @game.game_players.build
    @game.game_players.build

  end

  def create
    @game = Game.new(game_params)
    @game.game_players.each do |game_player|
      game_player.points.build
    end

    if @game.save
      redirect_to games_path, flash: {notice: "Game was created."}
    else
      render :new
    end
  end

  def update
    @game = Game.find(params[:id])
    if (params[:points][:score1]).length == 0 || (params[:points][:score2]).length == 0
      redirect_to game_path(@game), flash: { error: "Both points must be populated." }
    else
      @game.game_players[0].points << Point.create(score: params[:points][:score1])
      @game.game_players[1].points << Point.create(score: params[:points][:score2])

      redirect_to game_path(@game), flash: {notice: "Game updated."}
    end
  end

  def check_winner #End of Round win check
    @points_a = @game.game_players[0]
    @points_b = @game.game_players[1]

    if @points_a.total == 21 && @points_b.total == 21 || @points_a.total > 63 && @points_b.total > 63 #sudden death instance.
      @points_a = []
      @points_b = []
      #redirect_to sudden_death
    elsif @points_a.total == 21 || @points_b.total > 63
      @game.winner = @game.players[0]
      @game.save
    elsif @points_b.total == 21 || @points_a.total > 63
      @game.winner = @game.players[1]
      @game.save
    end
  end

  def set_winner
    @player = Player.find(params[:player])
    @game = Game.find(params[:game])
    if @game.set_winner(@player)
      redirect_to game_path(@game), flash: {notice: "#{@player.name} was set as winner for Game ID: #{@game.id}"}
    else
      redirect_to game_path(@game), flash: {error: "#{@player.name} was NOT set as winner for Game ID: #{@game.id}"}
    end
  end
  
  def destroy
    Game.find(params[:id]).destroy
    
    redirect_to games_path, flash: {notice: "Game was deleted."}
  end

  private

  def game_params
    params.require(:game).permit(game_players_attributes: [:player_id])
  end
end
