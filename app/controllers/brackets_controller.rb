class BracketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @brackets = current_user.brackets
    @brackets = @brackets.sort_by { |hsh| hsh[:created_at] }
    @brackets = @brackets.reverse
  end

  def show
    @bracket = Bracket.find(params[:id])
    @bracket.fill_losers
    @bracket.winner_check
    @games = @bracket.games
  end

  def new
    @bracket = Bracket.new
    @players = current_user.players
    @players = @players.sort_by { |hsh| hsh[:name] }
  end

  def create
    @bracket = Bracket.new
    @players = params[:game_players]

    array = []
    if @players.class != NilClass
      array = @players.map { |k,v| k }
    end
    
    if params[:bracket][:name] == "" || array.length < 4 || array.length > 16
      redirect_to new_bracket_path, flash: {error: "Error: Bracket requires name & Player count must be between 4 and 16."}
    else
      @bracket = Bracket.new(bracket_params)
      @bracket.user = current_user
      if @bracket.save
        @bracket.initial_create(array)
        redirect_to brackets_path, flash: {notice: "Bracket '#{@bracket.name}' was created."}
      else
        redirect_to new_bracket_path, flash: {error: "Error: Bracket name must be unique."}
      end
    end
  end

  def destroy
    Bracket.find(params[:id]).destroy
    
    redirect_to brackets_path, flash: {notice: "Bracket was deleted."}
  end

  private

  def bracket_params
    params.require(:bracket).permit(:name, game_players_attributes: [:id, :name])
  end
end
